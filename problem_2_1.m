% 读取 VTK 文件
v = readVTK('hydrogen.vtk');
v_double = double(v);
% 添加高斯噪声

sigma = 1.0e-5;
v_gaussian_noise = imnoise(v_double, 'gaussian', 0, sigma);

% 添加盐和胡椒噪声
density = 0.01;
v_salt_pepper_noise = imnoise(v_double, 'salt & pepper', density);

% 使用 3D 中值滤波去除噪声
v_gaussian_median_filtered = ordfilt3D(v_gaussian_noise, 14, 'replicate');
v_salt_pepper_median_filtered = ordfilt3D(v_salt_pepper_noise, 14, 'replicate');

% 使用 3D 均值滤波去除噪声
mean_filter = ones(3,3,3) / 27;
v_gaussian_mean_filtered = imfilter(v_gaussian_noise, mean_filter, 'replicate');
v_salt_pepper_mean_filtered = imfilter(v_salt_pepper_noise, mean_filter, 'replicate');


v = uint8(v);

v_gaussian_median_filtered = uint8(v_gaussian_median_filtered);
v_gaussian_mean_filtered = uint8(v_gaussian_mean_filtered);
v_salt_pepper_median_filtered = uint8(v_salt_pepper_median_filtered);
v_salt_pepper_mean_filtered = uint8(v_salt_pepper_mean_filtered);

% 计算 PSNR 和 SSIM 值
psnr_gaussian_median = psnr(v_gaussian_median_filtered, v);
ssim_gaussian_median = ssim(v_gaussian_median_filtered, v);

psnr_gaussian_mean = psnr(v_gaussian_mean_filtered, v);
ssim_gaussian_mean = ssim(v_gaussian_mean_filtered, v);

psnr_salt_pepper_median = psnr(v_salt_pepper_median_filtered, v);
ssim_salt_pepper_median = ssim(v_salt_pepper_median_filtered, v);

psnr_salt_pepper_mean = psnr(v_salt_pepper_mean_filtered, v);
ssim_salt_pepper_mean = ssim(v_salt_pepper_mean_filtered, v);

% 显示结果

volrender(v);
title('Original Image');

volrender(v_gaussian_noise);
title('Gaussian Noise');

volrender(v_gaussian_median_filtered);
title('Gaussian Noise - Median Filtered');

volrender(v_gaussian_mean_filtered);
title('Gaussian Noise - Mean Filtered');

volrender(v_salt_pepper_noise);
title('Salt & Pepper Noise');

volrender(v_salt_pepper_median_filtered);
title('Salt & Pepper Noise - Median Filtered');

volrender(v_salt_pepper_mean_filtered);
title('Salt & Pepper Noise - Mean Filtered');



% 打印 PSNR 和 SSIM 值
fprintf('Gaussian Noise - Median Filtered: PSNR = %f, SSIM = %f\n', psnr_gaussian_median, ssim_gaussian_median);
fprintf('Gaussian Noise - Mean Filtered: PSNR = %f, SSIM = %f\n', psnr_gaussian_mean, ssim_gaussian_mean);
fprintf('Salt & Pepper Noise - Median Filtered: PSNR = %f, SSIM = %f\n', psnr_salt_pepper_median, ssim_salt_pepper_median);
fprintf('Salt & Pepper Noise - Mean Filtered: PSNR = %f, SSIM = %f\n', psnr_salt_pepper_mean, ssim_salt_pepper_mean);