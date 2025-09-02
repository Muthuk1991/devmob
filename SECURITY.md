# Security Policy

## Security Considerations

DevMob is a development tool that requires elevated privileges for certain functionality. Please be aware of the following security implications:

### Docker Privileged Mode

DevMob containers run with `privileged: true` to enable:
- **Hardware acceleration** (KVM access for Android emulator)
- **GPU access** (for emulator graphics)
- **USB device access** (for physical Android devices)

**Security Impact:**
- Containers have elevated access to the host system
- Only run DevMob on trusted development machines
- Do not run untrusted code within DevMob containers
- Regularly update Docker and host system

### Network Access

DevMob uses `network_mode: "host"` to:
- Enable ADB connections to physical devices
- Allow Metro bundler to be accessible from mobile devices
- Support wireless debugging functionality

**Security Impact:**
- Container services are exposed on host network
- Firewall rules apply to container services
- Be cautious when using on shared networks

### File System Access

DevMob mounts several host directories:
- `/dev/dri` - GPU access
- `/dev/bus` - USB device access
- `/dev/kvm` - Hardware acceleration
- `/tmp/.X11-unix` - GUI forwarding
- Project directories - Source code access

**Security Impact:**
- Container can access mounted host resources
- Ensure project directories don't contain sensitive data

---

