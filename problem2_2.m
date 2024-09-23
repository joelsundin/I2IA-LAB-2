v = readVTK('hydrogen.vtk');
v = double(v);

array = zeros([size(v),27]);
for i = 1 : 27
    array(:,:,:,i) = imnoise(v,'gaussian', 0, 1.0e-5);
end

denoisedImage = zeros(size(v));
for i = 1 : 27
    denoisedImage = array(:,:,:,i)+denoisedImage;
end

denoisedImage = double(denoisedImage/27);

psnr_value = psnr(v, denoisedImage);
ssim_value = ssim(denoisedImage, v);


figure;

volrender(v);
title('original image');


volrender(denoisedImage);
title('denoised image');

fprintf('PSNR = %.2f, SSIM = %.4f\n', psnr_value, ssim_value);