# -- coding: utf-8 --
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
import math;
import time;
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
	lbp=local_binary_pattern(L,n_points,radius).astype(int);
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
def LBP(gray_array):
	m,n=gray_array.shape;
 	lbp=np.zeros((m,n));
	for i in range(1,m-1):
		for j in range(1,n-1):
			a=0;
			if(gray_array[i-1][j-1]>gray_array[i][j]):
				a=a+8;
			if(gray_array[i-1][j+1]>gray_array[i][j]):
				a=a+4;
			if(gray_array[i+1][j+1]>gray_array[i][j]):
				a=a+2;
			if(gray_array[i+1][j-1]>gray_array[i][j]):
				a=a+1;
			lbp[i][j]=a;
	return lbp;
start=time.clock();
pre_deal('./plane/00052.jpg');
end=time.clock();
print "Time:",(end-start)/60;
'''
def clusterStd(X,Y):
	m,n=X.shape;
	d=np.zeros((1,n));
	for i in range(m):
		for j in range(n):
			d[0][j]=d[0][j]+(X[i][j]-Y[j])**2;
	delta=(d/m)**0.5;
	return delta;
X=np.array([[1,2,3],[2,1,4],[3,4,1]]);
T=np.array([[1,2,1],[-1,1,-1]]);
B=np.array([[1,2,3]]);
re=np.where(X>2);
print re;
for i in range(len(re[0])/2):
	print X[re[0][i],re[1][i]];
print X;
pc=[];
pc.append(0);
pc.append(1);
p=X[pc,:];
tempcenter=np.array(map(sum,zip(*p)));
X[0,:]=tempcenter;
print tempcenter;
print X;
'''
'''
X=np.row_stack((X,X[0,:]));
X=np.delete(X,1,axis=0);
pc=[];
pc.append(0);
pc.append(1);
p=X[0,:];
re=np.where(p==np.max(p));
z=np.diag(X);
print max(p);
print re[0][0];
'''

'''
def disCount1(A,lbplen):
	m,n=A.shape;
	SB=np.zeros((m,m));
	SC=np.zeros((m,m));
	hsvlen=n-lbplen;
	B=A[:,0:lbplen];
	C=A[:,lbplen:n];
	for i in range(0,m):
		for j in range(i,m):
			b=B[i,:]-B[j,:];
			SB[i][j]=np.dot(b,b.T);
			SB[j][i]=SB[i][j];
	for i in range(0,m):
		for j in range(i,m):
			c=C[i,:]-C[j,:];
			SC[i][j]=np.dot(c,c.T);
			SC[j][i]=SC[i][j];
	S=SB/n*hsvlen+SC/n*lbplen;
	S=S**0.5;
	S=S*-1;
	mean=sum(S)/m/m;
	for i in range(0,m):
		S[i][i]=mean;	
	return S;
def distanceCount(A,lbplen):
	m,n=A.shape;
	hsvlen=n-lbplen;
	S=np.zeros((m,m));
	B=A[:,0:lbplen]*math.sqrt(hsvlen)/math.sqrt(n);
	C=A[:,lbplen:n]*math.sqrt(lbplen)/math.sqrt(n);
	T=np.hstack((B,C));
	for i in range(0,m):
		for j in range(i,m):
			t=T[i,:]-T[j,:];
			S[i][j]=np.dot(t,t.T);
			S[j][i]=S[i][j];
	S=S**0.5;
	S=S*-1;
	mean=sum(S)/m/m;
	for i in range(0,m):
		S[i][i]=mean;	
	return S;
A=np.array([[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]);
B=disCount1(A,3);
C=distanceCount(A,3);
print A;
print B;
print C;
'''

