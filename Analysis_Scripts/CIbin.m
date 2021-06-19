function R = CIbin(k,w,f,N)

r = zeros(1,N+1);
r(1) = 1;
  for n = 1:N
    r(n+1) = 2 * (besseli(n,k)/besseli(0,k))^2 * (sin(n*w*1e-3*pi*f)/(n*w*1e-3*pi*f));
  end
R=sum(r);
end