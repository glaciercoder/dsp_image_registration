tic
origin1_path = "./img_src/test_21.png";
origin2_path = "./img_src/test_22.png";
[imageA_path, imageB_path] = image_gen(origin1_path, origin2_path);
[imageA_path, imageB_path] = r_s_recover(imageA_path, imageB_path);
trans_recover(imageA_path, imageB_path)
toc

