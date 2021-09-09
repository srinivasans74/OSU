clc
clear all
EBNOdb=4;
x=64;
y=100;
z=1;
    for i =1:x
        for j=1:y
           B(i,j)=(randn(1)>0.5)
        end
    end
    
[u v] =size(B);

%Message
k= (v-u)*z;
p = v*z;
R= k/p;


%%% I calculated the noise varience sigma
EBNo= 10^(EBNOdb/10);
sigma =sqrt(1/(2*R*EBNo));
BER_the=0.5*erfc(sqrt(EBNo))


Nblocks=1;
Nerrors=0;
Sum=0;
iterations =10;
iter=1;

for i =1:Nblocks
    
    cword=randi([0,1],p,1);
    s=1-2*cword;
    r=s+sigma*randn(p,1);
    L=r;
end


%%% initilisations

for j =1 :v
    for i =1:u
        if(B(i,j)==0)
            B2(i,j)=0;
        else
            B2(i,j)=L(j);
        end
    end
end


Local=B2;
P=L'


while(iterations>iter)
    for i =1:u
            L1 = B2(i,:);
            S = sign(B2(i,:));
            [min1, index] = min(L1);
            L1(index) = [];
            min2 = min(L1);
            B2(i,:)=min1;
            B2(i,index)=min2;
            B2(i,:) = S.*B2(i,:); %assign signs


    end
    %%SISO Repetion code
    Buffa=zeros(1,p)
     for j =1:v
        Buffa(j)=Buffa(j)+P(j)+sum(B2(:,j))
        B2(:,j)=Buffa(j)-B2(:,j);
        
     end
   iter=iter+1; 
end
    
 
Decoded =(Buffa>0)

NErrors=sum(Decoded~=cword');
BER= NErrors/p;
format shortg
disp([EBNOdb,BER_the,BER,NErrors,p]);


