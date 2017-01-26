nFrame = 0;
cam=webcam;
cam.Resolution = '640x480';
J=snapshot(cam)*0;
se = strel('disk',8);
while(nFrame<150)
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
    %This is a loop to bound the red objects in a rectangular box.
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2), 'b*')
%         a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
%         set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
    end
    hold off
    nFrame=nFrame+1;
end
J2=imclose(J,se);
J2=imopen(J2,se);
figure;
imshow(J2);
imwrite(J2,'hello2.png');
clear cam;

