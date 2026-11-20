FROM busybox:1.37
COPY version.txt /version.txt
CMD ["cat", "/version.txt"]
