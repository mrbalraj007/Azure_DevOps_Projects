# Application Gateway URL Reference

## Direct URLs

These URLs access the VMs directly, bypassing the Application Gateway:

| Resource | URL | Status |
|----------|-----|--------|
| VM01 (Images) | http://VM01_IP/images/ | Working |
| VM02 (Videos) | http://52.191.28.128/videos/ | ✅ Working |

## Application Gateway URLs

These URLs go through the Application Gateway:

| Resource | URL | Status | Notes |
|----------|-----|--------|-------|
| Images | http://13.92.199.248/images/ | ✅ Working | Path-based routing |
| Videos | http://13.92.199.248/videos/ | ❌ Not Working | Use direct URL instead |
| Images (Hostname) | http://images.example.com/ | Requires hosts file | Host-based routing |
| Videos (Hostname) | http://videos.example.com/ | Requires hosts file | Host-based routing |
| Content (Path-based) | http://content.example.com/ | Requires hosts file | Use /images/ or /videos/ path |

## Accessing Videos

Since the Application Gateway route to videos is not working correctly, please use the direct URL:
http://52.191.28.128/videos/

Alternatively, you can use the videos_access.html file which will automatically redirect you to the correct location.

## Adding Hostname Entries

To use hostname-based routing, add these entries to your hosts file:

```
13.92.199.248 images.example.com
13.92.199.248 videos.example.com
13.92.199.248 content.example.com
13.92.199.248 videos-direct.example.com
```
