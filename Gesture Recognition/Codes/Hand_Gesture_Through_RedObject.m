nFrame=0;
cam=webcam;
cam.Resolution = '640x480';
J=snapshot(cam)*0;
click1=fliplr(snapshot(cam));
se = strel('disk',8);
while(nFrame<100)
    J=snapshot(cam)*0;
    click = fliplr(snapshot(cam));
    operated_image = imsubtract(click(:,:,1), rgb2gray(click));
    operated_image = medfilt2(operated_image, [3 3]);
    operated_image = im2bw(operated_image,0.18);
    operated_image = bwareaopen(operated_image,300);
    bw = bwlabel(operated_image, 8);
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    J=J+bw2rgb(operated_image);    
    img=click+J;
    imshow(img);
    hold on
    p1=151;p2=301;
    %This is a loop to bound the red objects in a rectangular box.
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
         p1=round(bc(1));
         p2=round(bc(2));
         k=[(p1-150) (p2-250) 255 255]
        rectangle('Position',k,'EdgeColor','b','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
    end
   
   
    hold off
   
    nFrame=nFrame+1;
end
I2=imcrop(click1,k);
I3=imcrop(click,k);

%  red=click(:,:,1);
% Green=click(:,:,2);
% Blue=click(:,:,3);
% Out(:,:,1)=red(min2:max2,min1:max1);
% Out(:,:,2)=Green(min2:max2,min1:max1);
% Out(:,:,3)=Blue(min2:max2,min1:max1);
% % Out(:,:,1)=red(min(r):max(r),min(c):max(c));
% % Out(:,:,2)=Green(min(r):max(r),min(c):max(c));
% % Out(:,:,3)=Blue(min(r):max(r),min(c):max(c));
% Out=uint8(Out);
% figure;
% imshow(Out);
% J2=imclose(J,se);
% J2=imopen(J2,se);
% figure;
% imshow(J2);
% imwrite(J2,'hello2.png');
I3=rgb2gray(I3);
I2=rgb2gray(I2);
c1=imsubtract(I3,I2);

d=im2bw(c1,0.1);
d=imclose(d,se);
d=imopen(d,se);
d=imfill(d,'holes');
% imshow(c1);
% impixelinfo
[r c]=size(d)

% c1=segment(I3,I2);
figure
imshow(I2);
figure
imshow(I3);
figure 
imshow (c1);
figure;
imshow(d);
str='.bmp';

for i=1:50
    a=strcat(num2str(i),str);
    b=imread(a);
    re1=corr2(b,d);
      fresultValues_r(i) = re1;
    fresultNames_r(i) = {a};
  
    result1(i)=re1
%     figure;
%     subplot(1,2,1);imshow(C1);
%     subplot(1,2,2);imshow(b);
%     xlabel(re1);
end

[re ma]=max(result1);
 a=strcat(num2str(ma),str);
b=imread(a);
figure;
imshow(b);title('recognition result');
[sortedValues_r, index_r] = sort(-fresultValues_r);     % Sorted results... the vector index

count1=0;
count2=0;
count3=0;
count4=0;
count5=0;
    fid = fopen('recognition.txt', 'w+');         % Create a file, over-write old ones.
for i = 1:10        % Store top 10 matches...
    
    
    
    imagename = char(fresultNames_r(index_r(i)));
    fprintf(fid, '%s\r', imagename);
    
    a=index_r(i)
    
    if a > 0 && a <=10
        
        count1=count1+1;
        
    elseif a > 10 && a <=20
        count2=count2+1;
    elseif a > 20 && a <=30
        count3=count3+1;
    elseif a > 30 && a <=40
        count4=count4+1;
    else
            count5=count5+1;
    end
    
    
    
end


Out =[count1 count2 count3  count4  count5];

 
 [Res ind]=max(Out);
 if(ma<10)
     q=1;
 elseif(ma<20)
         q=2;
 elseif(ma<30)
             q=3;
 elseif(ma<40)
                 q=4;
  else
                 q=5;
 end           
 warndlg(num2str(q));

clear cam;

