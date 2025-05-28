<div id="top"></div>

<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GPL-2.0 License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/open-img-cloud/amazon-linux-2">
    <img src="img/logo.png" alt="Logo" width="150" height="150">
  </a>

<h3 align="center">🚀 Amazon Linux 2 Cloud Images</h3>

  <p align="center">
    ☁️ Optimized Amazon Linux 2 images for OpenStack and Proxmox environments with cloud-init support
    <br />
    <br />
    <a href="https://github.com/open-img-cloud/amazon-linux-2"><strong>📖 Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/open-img-cloud/amazon-linux-2/issues">🐛 Report Bug</a>
    ·
    <a href="https://github.com/open-img-cloud/amazon-linux-2/issues">💡 Request Feature</a>
  </p>
</div>

<!-- ABOUT THE PROJECT -->
## 🌟 About The Project

This project provides optimized Amazon Linux 2 images specifically designed for OpenStack and Proxmox cloud environments. Amazon Linux 2 is AWS's enterprise-grade Linux distribution that provides a stable, secure, and high-performance execution environment for applications.

Our build process downloads the official Amazon Linux 2 KVM images directly from [AWS's public repository](https://cdn.amazonlinux.com/os-images/) and customizes them using libguestfs tools to ensure seamless OpenStack integration. The customization process includes:

- **☁️ Cloud-init integration:** Enhanced OpenStack datasource configuration for automated provisioning
- **🔧 Minimal modifications:** Preserves the original Amazon Linux 2 experience with only essential cloud adaptations
- **📦 Clean deployment:** Ready-to-use images with optimized cloud-init configuration
- **💾 Storage optimization:** Image sparsification and compression for efficient deployment

### ✨ Key Features

- **🏢 Enterprise-ready:** Based on AWS's production-grade Amazon Linux 2 distribution
- **🔒 Security-focused:** Inherits AWS security standards and regular updates
- **⚡ Performance optimized:** Lightweight and efficient for cloud workloads
- **🌐 Cloud-native:** Full cloud-init support with OpenStack-specific datasources
- **🤖 Automated builds:** Images automatically updated when AWS releases new versions
- **🔄 Minimal changes:** Maintains compatibility with existing Amazon Linux 2 workflows

### 📅 Update Schedule

Images are automatically built and released when AWS publishes new Amazon Linux 2 versions on their [official repository](https://cdn.amazonlinux.com/os-images/latest/). The CI/CD pipeline ensures fresh images with the latest security updates and cloud optimizations.

<p align="right">(<a href="#top">back to top</a>)</p>

## 🚀 How to use this image

### ☁️ OpenStack

1. Set your OpenStack environment variables
2. Download the latest image from the [📥 repository page](https://repo.openimages.cloud/amazon-linux-2 "Repository page")
3. Upload image to your OpenStack environment:
   ```sh
   openstack image create --disk-format=qcow2 --container-format=bare --min-disk 25 --file amzn2-kvm-<VERSION>-x86_64.xfs.gpt.qcow2 'Amazon Linux 2'
   ```

### 🖥️ Proxmox VE

1. Download the latest image from the [📥 repository page](https://repo.openimages.cloud/amazon-linux-2 "Repository page")
2. Copy the image to your Proxmox storage:
   ```sh
   scp amzn2-kvm-<VERSION>-x86_64.xfs.gpt.qcow2 root@proxmox-host:/var/lib/vz/template/iso/
   ```

3. Create a new VM using the uploaded image:
   ```sh
   # Create VM with cloud-init support
   qm create <VMID> --name amazon-linux-template --memory 1024 --cores 2 --net0 virtio,bridge=vmbr0
   
   # Import the disk
   qm importdisk <VMID> amzn2-kvm-<VERSION>-x86_64.xfs.gpt.qcow2 <STORAGE>
   
   # Configure the VM
   qm set <VMID> --scsihw virtio-scsi-pci --scsi0 <STORAGE>:vm-<VMID>-disk-0
   qm set <VMID> --boot c --bootdisk scsi0
   qm set <VMID> --ide2 <STORAGE>:cloudinit
   qm set <VMID> --serial0 socket --vga serial0
   ```

4. Configure cloud-init settings:
   ```sh
   # Example cloud-init configuration
   qm set <VMID> --ciuser ec2-user --cipassword <PASSWORD>
   qm set <VMID> --sshkeys ~/.ssh/authorized_keys
   qm set <VMID> --ipconfig0 ip=dhcp
   ```

### 🔧 Default Configuration

- **Default user:** `ec2-user` (maintains AWS compatibility)
- **SSH access:** Key-based authentication enabled by default
- **Cloud-init:** Configured with OpenStack, NoCloud, and ConfigDrive datasources
- **Package manager:** YUM with security updates enabled
- **Root access:** Disabled by default (use sudo with ec2-user)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## 🤝 Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! ⭐ Thanks again!

1. 🍴 Fork the Project
2. 🌿 Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. 💾 Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. 📤 Push to the Branch (`git push origin feature/AmazingFeature`)
5. 🔀 Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- LICENSE -->
## 📄 License

Distributed under the GPL-2.0 License. See `LICENSE.md` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTACT -->
## 📞 Contact

Kevin Allioli - [🐦 @NetArchitect404](https://x.com/NetArchitect404) - 📧 kevin@netarch.cloud

Project Link: [🔗 https://github.com/open-img-cloud/amazon-linux-2](https://github.com/open-img-cloud/amazon-linux-2)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/open-img-cloud/amazon-linux-2.svg?style=for-the-badge
[contributors-url]: https://github.com/open-img-cloud/amazon-linux-2/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/open-img-cloud/amazon-linux-2.svg?style=for-the-badge
[forks-url]: https://github.com/open-img-cloud/amazon-linux-2/network/members
[stars-shield]: https://img.shields.io/github/stars/open-img-cloud/amazon-linux-2.svg?style=for-the-badge
[stars-url]: https://github.com/open-img-cloud/amazon-linux-2/stargazers
[issues-shield]: https://img.shields.io/github/issues/open-img-cloud/amazon-linux-2.svg?style=for-the-badge
[issues-url]: https://github.com/open-img-cloud/amazon-linux-2/issues
[license-shield]: https://img.shields.io/github/license/open-img-cloud/amazon-linux-2.svg?style=for-the-badge
[license-url]: https://github.com/open-img-cloud/amazon-linux-2/blob/master/LICENSE.md
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/kevinallioli
