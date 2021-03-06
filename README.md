
# DSP_1

## Background:

Use Fourier-Mellin based method to registrate images with a rigid body transformation

## Theories and Principles

### Correlation method

The correlation(unnormalized) is defined as
$$
R(i,j) = \sum_{l = 1}^M\sum_{m = 1}^MW(l,m)S^{i,j}_M(l,m),i,j \in[1,L-M+1]
$$
It is clear that unnomalized correlation can not be used to registrate, so nomalization is necessary
$$
R^2_N(i,j) = \frac{(\sum_{l = 1}^M\sum_{m = 1}^MW(l,m)S^{i,j}_M(l,m))^2}{(\sum_{l = 1}^M\sum_{m 
= 1}^MW(l,m))^2(\sum_{l = 1}^M\sum_{m = 1}^MS^{i,j}_M(l,m))^2},i,j \in[1,L-M+1]
$$

### SSDA

Every time a reference point is given, there will be $M^2$ multiplications. We call $<W(l,m),S^{i,j}_M(l,m)>$ a *window pair*. The complexity of the primitive algorithm originates from the fact that not every window pair is important and worth $M^2$ times calculation.

SSDA reduces this redundancy by performing a sequential search which may be terminated before all $M^2$ windowing pairs for a particular reference point are tested.

The basic idea of the SSDA is 

1. Define the distance of the pictures
2. Choose a sequence for inceasing-scale image and calculate their distance
3. Set a threshold, and take down the index in sequence that the distance exceeds the threshold.
4. Construct the SSDA surface and check the correlation according to this

#### An example with constant SSDA

Define the distance as:

- Unnormalized
  $$
  d'(i,j,l_n,m_n)=|S^{i,j}_M(l_n,m_n)-W(l_n,m_n)|
  $$

- Normalized

$$
d(i,j,l_n,m_n)=|S^{i,j}_M(l_n,m_n)-W(l_n,m_n)+\hat{W}-\hat{S}(i,j)|\\
\hat{W} = \frac{1}{M^2}\sum_{l = 1}^{M}\sum_{m = 1}^MW(l,m) \\
\hat{S}(i,j) = \frac{1}{M^2}\sum_{l = 1}^{M}\sum_{m = 1}^MS^{i,j}_M(l,m)
$$

We use a constant T as the threshold. The SSDA surface

$$
I(i,j) = \{r | \min_{1\leq r\leq M^2}\{\sum_{n = 1}^r d(i,j,l_n,l_m)\geq T\}\}
$$
Reference points where $I(i,j)$ is large (those which require many windowing pair tests to exceed T) are considered points of similarity

### Generalization

Now we consider the gerneral situation for registration of translation. We have two images A and B, they have some areas that is common. To registrate two images, we mean finding the translational vector $u = (u_x,u_y)$. We define
$$
(x,y)_A
$$
as the coordinate in A coordination. Then
$$
(x+u_x,y+u_y)_A = (x,y)_B
$$
We do this by the following steps:

#### Choose one window pair

We choose the window pair as:

A_cut(Searching Area): $(x_{A1},y_{A1},x_{A2},y_{A2})_A$

B_cut(Window): $(x_{B1},y_{B1},x_{B2},y_{B2})_B$

#### Update window pair

Using SSDA-like method to update the window pair.

#### Calculate the Correlation and find the peak

Suppose we get the coordinate of the peak $(x_0,y_0)_{A_{cut}}$, then
$$
(x,y)_{B_{cut}} = (x+x_0,y+y_0)_{A_{cut}}
$$

#### Align the image

$$
(x,y)_B = (x-x_{B1},y-y_{B1})_{B_{cut}} = (x-x_{B1}+x_0,y-y_{B1}+y_0)_{A_{cut}} = (x+x_{A1}-x_{B1}+x_0,y+y_{A1}-y_{B1}+y_0)_A \\
\Rightarrow u = (x_{A1}-x_{B1}+x_0,y_{A1}-y_{B1}+y_0)_A
$$

### Fourier-Mellin Method

Suppose we have a reference image $r$(the original one) and a pattern image $ p$ related by RST transformation:
$$
r(x,y) = p(\Delta x+s*(x\cos \phi-y\sin\phi),\Delta y+s*(x\sin\phi+y\cos\phi))
$$
  Their frquency is related by 
$$
F_s(\omega_x,\omega_y) = s^2F_p((\omega_x\cos\phi+\omega_y\sin\phi)/s,(-\omega_x\sin\phi+\omega_y\cos\phi)/s )\exp(j2\pi(\omega_x\Delta x+\omega_y\Delta y)/s)
$$
The magnitude of $F_p$ is derived from the magnitude of $F_r$ by rotating Fr by $-\phi$ and shrinking its extent by a factor of $s$.

The translation has its effect the phase rather than on the magnitude, so the magnitude is invariant under the tranlational transform. This is called **Fourier-Mellin Invariance**. The magnitude domain is referred to as the **Fourier-Mellin domain**, denote
$$
R = |F_r| \\
P = |F_p|
$$
By operating in Fourier-Mellin domain, translation is decoupled with rotation and scale, so the next step is to decouple the rotation and scale. This is done by transforming to log-polar space.

### Log-polar analysis

We transform the Cartesian to polar
$$
\rho = \sqrt{\omega_x^2+\omega_y^2} \\
\theta = \arctan\frac{\omega_y}{\omega_x}
$$
and define a rotation invariant 
$$
S_r(\log \rho) = \frac{1}{\rho}\int_0^\pi R(\rho\cos\theta,\rho\sin\theta)d\theta
$$
Then by correlation of $S_r$, translation parameter can be found. 

We can also tranform R and P both, suppose
$$
M_1(\log\rho,\theta) = R(\omega_x,\omega_y) \\
M_2(\log\rho,\theta) = P(\omega_x,\omega_y) \\
$$
Then we have
$$
M_1(\log\rho,\theta) = M_2(\log\rho-\log s,\theta-\phi)
$$

## Algorithm

### Translation























```flow
  st=>start: Start
  
  in1=>inputoutput: input image_A & image_B
  out=>inputoutput: output image_A & image_B
  out1=>inputoutput: output the most similar part
  out2=>inputoutput: output subregions of each image

  o1=>operation: crop image_B into 4 parts
  o2=>operation: choose window & searching_area
  o3=>operation: repair image_A & image_B
  o4=>operation: SSDA
  o5=>operation: SSDA

  cond1=>condition: size_A < size_B ?
  cond2=>condition: size_B > size_A/2 ?

  s1=>subroutine: larger_and_smaller
  s2=>subroutine: max_threshold_ind
  s3=>subroutine: normxcorr2
  s4=>subroutine: max

  e=>end
  
  st->in1->cond1
  cond1(yes)->s1->out
  cond1(no)->out
  out->cond2
  cond2(no)->o1(right)->o4->out1(left)->s2->o5(right)->out2(right)->s3
  s3->s4->o3->e
  cond2(yes)->s2

```

### Translation & scale & rotation































































```flow
st=>start: Start

in1=>inputoutput: input image_A & image_B
in2=>inputoutput: input scale roughly
out=>inputoutput: output image_A & image_B
out1=>inputoutput: output scale roughly
out2=>inputoutput: output scale accurately
out3=>inputoutput: output angle rotate
out4=>inputoutput: output final image rotate scale

o=>operation: calculate final scale

cond1=>condition: size_A < size_B ?
cond2=>condition: AOS == 'angle' ?
cond3=>condition: AOS == 'scale_acc' ?
cond4=>condition: AOS == 'scale_rough' ?

s1=>subroutine: larger_and_smaller
s2=>subroutine: max_threshold_ind
s3=>subroutine: normxcorr2
s4=>subroutine: max
s5=>subroutine: imrotate
s6=>subroutine: R_and_centerind
s7=>subroutine: recover_angle_or_scale( , ,'scale_rough')
s8=>subroutine: imresize
s9=>subroutine: trans_recover
s10=>subroutine: recover_angle_or_scale( , ,'angle')
s11=>subroutine: recover_angle_or_scale( , ,'scale_acc')

e=>end

st->in1->cond1
cond1(no)->s1->out
cond1(yes,right)->out
out(right)->s7(right)->s10->s11->out2
out2->out4->s5->s8->s9->e

```

## Result

### Translation

- Original two pictures

![avatar](./img_src/test.png)|![avatar](./img_src/test_2.png)
:-:|:-:
test.png|test_2.png

![avatar](./img_src/test_21.png)|![avatar](./img_src/test_22.png)
:-:|:-:
test_21.png|test_22.png

- Pair of them

![avatar](./img_src/translation_alone_result.png)
![avatar](./img_src/translation_alone_result2.png)

### Translation & scale & rotation

- Original two pictures

![avatar](./img_src/test_21.png)|![avatar](./img_src/pair.png)
:-:|:-:
test_21.png|pair.png

- Pair of them

![avatar](./img_src/result_demo.png)

## Summary

- Attentions when using matlab
  - Matlab store a image as a row $\times$ Columns matrix. However, to choose an index, the format is (column, row)
  - Matlab stores the RGB value in **uint8** format and downcast all the valriables in the same expression with RGB value to uint8 and cause the calculation result to be wrong.
  
- The correlation method has a complexity of $\mathcal{O}(n^4)$. Using FFT will improve a lot, but still cost much time, that is where **SSDA(sequential similarity detection algorithms)** comes in.
- The differences between rotation/scale and translation
  - Unlike the traslational situation, where no loss in data, roatation and scale always need to interpolation and may lose information. Differences for occlusion is considered as an important part.
- The result of demo.m shows good registration effect, and based on the SSDA, it takes about 40 seconds, which is much faster than using correlation method.
- However, we did not quantitatively analysis the effect of the registration. Highly hope TA could give some suggestion!

## Reference

[Image Registration](https://zhuanlan.zhihu.com/p/80985475)

[Definition of CSD(cross-spectral-density)](https://en.wikipedia.org/wiki/Spectral_density)

[An Image Registration Review](https://www.sciencedirect.com/science/article/pii/S0262885603001379)

[A matlab example using CC method](https://www.mathworks.com/help/images/registering-an-image-using-normalized-cross-correlation.html)

Registration algorithms attempt to align a pattern image over a reference image so that pixels present in both images are in the same lo cation
