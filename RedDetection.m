vid = videoinput('winvideo',1,'YUY2_320X240');

set(vid,'FramesPerTrigger',Inf);
set(vid,'ReturnedColorSpace','rgb');
% To take the images from the videos after every five minutes
vid.FrameGrabInterval = 5;

start(vid)

while(vid.FramesAcquired<=100)
    
    data = getsnapshot(vid);
    % Now to track a red object in realtime we subtract the red component
    % from the grayscale image to extract the red components in the image
    
    diff_im = imsubtract(data(:,:,1),rgb2gray(data));
    diff_im = medfilt2(diff_im,[3,3]);
    diff_im=imbinarize(diff_im,0.18);
    diff_im = bwareaopen(diff_im,300);
    
    
    bw = bwlabel(diff_im,8);
    
    stats = regionprops(bw,'BoundingBox','Centroid');
    imshow(data);
    
    hold on
    for object=1:length(stats)
        bb=stats(object).BoundingBox;
        bc= stats(object).Centroid;
        
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2);
        % Use the plot function to plot the rectangles drawn in the output
        plot(bc(1),bc(2),'-m+')
    end
    hold off
end
stop(vid);
flushdata(vid);

