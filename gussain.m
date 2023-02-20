function G = gussain(filtered)
    pic=double(filtered);
    d0=90;
    [m,n]=size(pic);
    n1=floor(m/2);
    n2=floor(n/2);
    f4=fftshift(fft2(double(pic)));
    for u=1:m
        for v=1:n
            D=sqrt((u-n1)^2+(v-n2)^2);
            H=1*exp(-1/2*(D^2/d0^2));
            G(u,v)=H*f4(u,v);
        end
    end
end

