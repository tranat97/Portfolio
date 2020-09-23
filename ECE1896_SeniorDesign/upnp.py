import upnpy

upnp = upnpy.UPnP()
devices = upnp.discover()

print(len(devices))
for x in devices:
    print("Device: " + x)