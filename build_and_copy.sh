./build.py
rm -rf modules
unzip com.limechalk.timessage-iphone-1.0.zip

# remove the module on test app
rm -rf ../Test/modules/iphone/com.limechalk.timessage
cp -R modules/iphone/com.limechalk.timessage ../Test/modules/iphone/com.limechalk.timessage


