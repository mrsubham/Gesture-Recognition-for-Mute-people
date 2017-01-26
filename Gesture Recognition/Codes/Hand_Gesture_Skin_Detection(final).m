
clear all;  

n=0;
   cam=webcam;
   se = strel('disk',2);
cam.Resolution = '640x480';

  while(n<40)
    %Read the image, and capture the dimensions
    img_orig = snapshot(cam);
    img_orig=fliplr(img_orig);
    height = size(img_orig,1);
    width = size(img_orig,2);
    
    %Initialize the output images
    out = img_orig;
    bin = zeros(height,width);
    
    %Apply Grayworld Algorithm for illumination compensation
   % img = grayworld(img_orig);    
    img=img_orig;
    %Convert the image from RGB to YCbCr
    img_ycbcr = rgb2ycbcr(img);
    Cb = img_ycbcr(:,:,2);
    Cr = img_ycbcr(:,:,3);
    n=n+1;
    %Detect Skin
    [r,c,v] = find(Cb>=80 & Cb<=135 & Cr>=130 & Cr<=173);
    numind = size(r,1);
    
    %Mark Skin Pixels
    for i=1:numind
        out(r(i),c(i),:) = [0 0 255];
        bin(r(i),c(i)) = 1;
    end
    operated_image=bin;
    operated_image = medfilt2(operated_image, [3 3]);
   
    operated_image = bwareaopen(operated_image,300);
   
    %imshow(img_orig);
   % figure; 
   imshow(out);
   
    %figure; imshow(bin);
  end
  [ bw, num] = bwlabel(operated_image, 8);
    stats = regionprops(bw, 'BoundingBox','Area', 'Centroid');
   center=cat(1,stats.Centroid);
area=[stats.Area];
[pixelArea, index]=max(area);
box1=stats(index).Centroid;
p1=round(box1(1));
p2=round(box1(2));
box=[(p1-140) (p2-150) 255 255];
%area=box(3)*box(4);
rectangle('Position',box,'EdgeColor','r');
  I3=imcrop(operated_image,box);
  I3=imclose(I3,se);
  figure
  imshow(I3);
  str='.bmp';
str1='F'
for i=1:50
    a=strcat(num2str(i),str);
    b=imread(a);
    re1=corr2(b,I3);
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
     q='Go there';
 elseif(ma<20)
         q='Two minute break';
 elseif(ma<30)
             q='Phone Call';
 elseif(ma<40)
                 q='Good Work';
  else
                 q='Hi five';
 end           
 warndlg(q);
 tts(q);


  clear cam