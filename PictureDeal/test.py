# -- coding: utf-8 --
from __future__ import division
from PIL import Image;
from skimage.feature import local_binary_pattern;
from skimage import color;
import skimage;
import numpy as np;
import matplotlib.colors as colors;
from numpy import random as rd;
from numpy import *;
import scipy.io as sio;
import os;
from sklearn.cluster import AffinityPropagation
from sklearn import metrics
import shutil
import time
import sys
def compressPic():
	folderPath = r"./picture/"  # pic folder path
	tfile = os.listdir(folderPath)
	picSet = []
	for picIdx in range(0, len(tfile)):
    		infile = folderPath + "/" + tfile[picIdx]
    		p, fe = os.path.split(infile)
    		f, e = os.path.splitext(fe)
    		outputFp = f + ".jpg"
    		picSet.append(outputFp)
    		normal_outfile = r"./download/" + outputFp  #output filepath
    		im = Image.open(infile)
    		im_ratio = im.width / im.height
    		normal_out = im.resize((int(480 * im_ratio), 480))  # Set resolution
    		normal_out.save(normal_outfile, quality=95)  # set quality (0-100) default=95
#统计0--n-1对应数值
def countNum(x,n):
	count=np.zeros((1,n));
	for i in range(0,n):
		z=x[x==i];
		count[0][i]=z.size;
	return count;
#统计在（m,n）范围内的数值HSV
def countHR(x,m,n):
	p=[j for i in x for j in i if m<=j<n];
	return len(p);
#矩阵归一化
def normalize(x):
	m,n=x.shape;
	result=np.zeros((1,n));
	result[0][0]=x[0][0]
	for i in range(1,n):
		result[0][i]=result[0][i-1]+x[0][i];
	return result;
#计算行向量x行矩阵与y中各行距阵的距离
def distanceCount(x,y):
	n=y.shape[0];
	r=np.tile(x,(n,1));#copy
	z=r-y;
	p=np.dot(z,z.T);#乘积
	d=np.diag(p);#对角
	d=d**0.5;
	filenum=np.where(d==min(d));
	return (d,filenum[0][0]);
#cmyk转换为rgb
def cmyk_to_rgb(x):
	t1=x[:,:,0:3];
	m,n,r=t1.shape;
	t2=np.array([[[255 for i in range(r)] for j in range(n)] for k in range(m)]);
	return t2-t1;
#判断是否为彩色图像
def judge_picture(x):
	I=Image.open(x);
	L=I.convert('L');#灰度图
	I_array=np.array(I);
	if len(I_array.shape)==2:
		return 0;
	else:
		return 1;
#初步获取图像的lbp特征和h特征
def pre_deal(x):
	I=Image.open(x);
	L=I.convert('L');#灰度图
	I_array=np.array(I);
	if I_array.shape[2]==4:
		rgb_array=cmyk_to_rgb(I_array);
	else:
		rgb_array=I_array;
	gray_array = np.array(L);#由灰度图像转为数组
	hsv_array=colors.rgb_to_hsv(rgb_array);
	h=(hsv_array[:,:,0]*360+0.5).astype(int);#色度H[0,360]
	radius=1;
	n_points=8*radius;
	lbp=local_binary_pattern(L,n_points,radius).astype(int);#LBP特征[0,255]
	m,n=h.shape;
	lc=countNum(lbp,256).astype(float)/(m*n)*100;
	hc=np.zeros((1,12));
	hc[0][0]=len([j for i in h for j in i if 345<=j<=360])*100.0/(m*n)+countHR(h,0,15)*100.0/(m*n);
	for i in range(1,12):
		hc[0][i]=countHR(h,15+(i-1)*30,15+i*30)*100.0/(m*n);
	result_h=normalize(hc);
	result_lbp=normalize(lc);
	r_l_h=np.concatenate([result_lbp,result_h],axis=1);
	return r_l_h;
#预测单张图片的图片集号
def predict_num(x):
	lbplen=256;
	center=sio.loadmat('./clustercenter.mat')['clustercenter'];
	'''
	im = Image.open(x)
    	im_ratio = im.width / im.height
    	normal_out = im.resize((int(480 * im_ratio), 480))
	normal_out.save(normal_outfile, quality=95);
	'''
	r_l_h=pre_deal(x);
	r_l_h=reRange(r_l_h,lbplen);
	num=distanceCount(r_l_h,center)[1];
	return num;
#处理所有图片获取特征矩阵
def pre_dealAll():
	picname=[];
	for pn in os.listdir(r"./download"):
		pn="./download/"+pn;
		if(judge_picture(pn)==1):
			picname.append(pn);
	print len(picname);
	picfeature=pre_deal(picname[0]);
	for i in range(len(picname)):
		if i==0:
			continue;
		else:
			picfeature=np.concatenate((picfeature,pre_deal(picname[i])));#np.vstack
	m,n=picfeature.shape;
	print m,n;
	return picfeature,picname;
#存储特征矩阵
def saveFormat():
	A,picname=pre_dealAll();
	dataNew='./featureAll.mat';
	sio.savemat(dataNew,{'A':A});
	return picname;
#计算距离矩S
def disCount(A):
	m,n=A.shape;
	S=np.zeros((m,m));
	for i in range(0,m):
		for j in range(i,m):
			a=A[i,:]-A[j,:];
			S[i][j]=np.dot(a,a.T);
			S[j][i]=S[i][j];
	S=S**0.5;
	mean=sum(S)/m/m;
	for i in range(0,m):
		S[i][i]=mean;
	return S;
#重新按比例组织特征矩阵
def reRange(A,lbplen):
	m,n=A.shape;
	hsvlen=n-lbplen;
	B=A[:,0:lbplen]*math.sqrt(hsvlen)/math.sqrt(n);
	C=A[:,lbplen:n]*math.sqrt(lbplen)/math.sqrt(n);
	T=np.hstack((B,C));
	return T;
#将图片存储至相应的文件夹中
def arrangeFolder(labels,picname):
	for i in range(len(picname)):
		shutil.copy(picname[i], "./ISODATA/"+str(labels[i]));
#创建文件夹		
def creatFolder(n):
	for i in range(n):
		mkpath="./ISODATA/"+str(i);
		os.mkdir(mkpath);
#AP聚类		
def ap(A):
	print A.shape;
	af = AffinityPropagation().fit(A);
	cluster_centers_indices = af.cluster_centers_indices_;	
	labels = af.labels_;	
	n_clusters_ = len(cluster_centers_indices);	
	return (cluster_centers_indices,labels,n_clusters_);
#计算标准差
def clusterStd(X,Y):
	m,n=X.shape;
	d=np.zeros((1,n));
	for i in range(m):
		for j in range(n):
			d[0][j]=d[0][j]+(X[i][j]-Y[j])**2;
	delta=(d/m)**0.5;
	return delta;
#对AP聚类结果进行预处理
def countCenter(A,cluster_centers_indices,labels,length_center):
	precenter=A[cluster_centers_indices,:];
	m,n=A.shape;
	stdvar=np.zeros((1,n));
	minnumber=m;
	pc=[];
	S=disCount(precenter);
	mindistance=S.min();
	for i in range(length_center):
		I=[j for j in range(len(labels)) if labels[j]==i];
		stdvar=stdvar+clusterStd(A[I,:],precenter[i,:]);
		if minnumber>len(I):
			minnumber=len(I);
	stdvarmean=sum(stdvar)/n/length_center;
	if(minnumber<int(m*1.0/length_center/3*2)):
		minnumber=int(m*1.0/length_center/3*2);
		for i in range(length_center):
			I=[j for j in range(len(labels)) if labels[j]==i];
			if(len(I)>=minnumber):
				pc.append(i);
	precenter=precenter[pc,:];
	length_center=len(precenter);
	return (precenter,length_center,minnumber,stdvarmean,mindistance);
#判断分裂还是合并
def stepJudge(optime,nc,opcount,k):
	if(optime==opcount):
		y=2;
	else:
		if(nc>k*2 or optime%2==0):
			y=0;
		else:
			y=1;
	return y;
#ISODATA二次聚类
def isodata(precenter,x,number,clusternumber,leastnumber,stdvar,mindistance,opcount):
	k=clusternumber;
	qn=leastnumber;
	qs=stdvar;
	qc=mindistance;
	num=number;
	factor=0.5;
	z=precenter;
	nc=precenter.shape[0];
	optime=1;
	n=x.shape[0];
	while(optime<opcount):
		count=np.zeros((1,nc));
		aved=np.zeros((1,nc));
		labels=[];
		avedAll=0;
		for m in range(n):
			label_num=distanceCount(x[m,:],z)[1];
			labels.append(label_num);
			count[0][label_num]=count[0][label_num]+1;
		for i in range(nc):
			I=[j for j in range(len(labels)) if labels[j]==i];
			temp=x[I,:];
			tempcenter=np.array(map(sum,zip(*temp)))/len(I);
			z[i,:]=tempcenter;
			aved[0][i]=sum(distanceCount(tempcenter,temp)[0])/len(I);
			avedAll=avedAll+aved[0][i]*len(I);
		avedAll=avedAll/sum(count);
		judge=stepJudge(optime,nc,opcount,k);
		nct=nc;
		if(judge==1):#分裂
			stdcluster=np.zeros((nc,num));
			for i in range(nc):
				I=[j for j in range(len(labels)) if labels[j]==i];
				temp=x[I,:];
				stdcluster[i,:]=clusterStd(temp,z[i,:]);
				p=stdcluster[i,:];
				maxqs=np.max(p);
				ind=np.where(p==np.max(p))[0][0];
				if(maxqs>qs and ((aved[0][i]>avedAll and count[0][i]>2*(qn+1)) or nc<=k/2)):
					lqs=z[i][ind]+factor*maxqs;
					hqs=z[i][ind]-factor*maxqs;
					t=np.row_stack((z,z[i,:]));
					t[nct][ind]=lqs;
					t[i][ind]=hqs;
					z=t;
					nct=nct+1;
			nc=nct;
		elif(judge==0):
			centerD=disCount(z);
			for i in range(centerD.shape[0]):
				centerD[i][i]=centerD.max();
			re=np.where(centerD<qc);
			for i in range(int(len(re[0])/2)):
				a=re[0][i];
				b=re[1][i];
				if(b==z.shape[0]):
					b=b-1;
				tempcenter=(z[a,:]*count[0][a]+z[b,:]*count[0][b])/(count[0][a]+count[0][b]);
				z=np.delete(z,b,axis=0);
				z[a,:]=tempcenter;
				nc=nc-1;
		else:
			optime=opcount;
		optime+=1;
	clustercenter=z;
	labels=[];
	for m in range(n):
		label_num=distanceCount(x[m,:],z)[1];
		labels.append(label_num);
	return (clustercenter,labels);
def maindeal_All():
	start1=time.clock();
	#compressPic();
	A,picname=pre_dealAll();
	end1=time.clock();
	print "Time:",(end1-start1)/60;
	lbplen=256;
	hsvlen=12;
	featurelen=lbplen+hsvlen;
	A=reRange(A,lbplen);
	cluster_centers_indices,labels,length_center=ap(A);
	precenter,length_center,minnumber,stdvarmean,mindistance=countCenter(A,cluster_centers_indices,labels,length_center);
	opcount=2000;
	clustercenter,clusterlabel=isodata(precenter,A,featurelen,length_center,minnumber,stdvarmean,mindistance,opcount);
	print clustercenter.shape;
	print clusterlabel;
	creatFolder(clustercenter.shape[0]);
	arrangeFolder(clusterlabel,picname);
	end=time.clock();
	print "Time:",(end-start1)/60;
	dataNew='./clustercenter.mat';
	sio.savemat(dataNew,{'clustercenter':clustercenter});
	return picname,clusterlabel;
#picname,clusterlabel=maindeal_All();
#num=predict_num('atm2.jpg');
