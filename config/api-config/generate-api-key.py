import codecs;
f=open('/liteserver/liteserver.pub', "rb+")
pub=f.read()[4:]
print(str(codecs.encode(pub,"base64")).replace("\n","")[2:46])