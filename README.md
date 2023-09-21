![dt-logo-full-aot-space-w1280](https://user-images.githubusercontent.com/83282694/116271495-5219b100-a780-11eb-9e1a-f929d2e3cbdc.png)

# deviceTRUST Demo-Box

We at deviceTRUST aim to make our software, its understanding and presentation as simple and straight forward as possible. We understand the need of demos to be easy and clear. Aiming to offer you the possibility of presenting deviceTRUST and its functionalities in a most efficient and comprehensible way, we came up with the deviceTRUST Demo-Box and the deviceTRUST Demo-Tool.

The deviceTRUST Demo-Box is an automated process for converting an existing standalone Microsoft Server into a simple, fully functional deviceTRUST demo environment without the need to set up a full lab environment.

After running the setup script, just add your personal deviceTRUST license inside the deviceTRUST Console and you are ready to demonstrate deviceTRUST to your colleagues, customers or friends.

The deviceTRUST Demo-Box comes with our deviceTRUST Demo-Tool. The Demo-Tool is used to easily set different states of your endpoint during demonstrations. It is part of the deviceTRUST Demo-Tool download.

## Before you start

- Client Prerequisites: For now, the Demo-Box is only usable with a Windows based client. Our Demo-Tool can only be executed on Windows based devices and is required for utilizing the Demo-Box.

- Default credentials

  - user/dT$

  - admin/dT$

- VM Prerequisites

  - Microsoft Server 2016, 2019 or 2022 

  - 2 vCPUs, min. 2 GB RAM, 60 GB hard disk

  - Please prepare an updated Windows Server machine. It needs to be in a workgroup. No other requirements. The deviceTRUST Demo-Box process will implement all necessary changes and customizations. Please apply all personal changes (e.g., server name) after finishing the setup.

## Installation

There is a single PowerShell script to install the Demo-Box. Please execute the following command in an elevated PowerShell Session. You can obviously check the file's content before execution. Safety first! :)

```powershell
Invoke-Expression $((Invoke-WebRequest https://raw.githubusercontent.com/deviceTRUST/demo-box/main/dt-demo-box.ps1).content)
```

The script will install everything required for your Demo-Box implementation. You'll be asked to restart the machine once finished

## License

A valid license is required and needs to be added to the configuration before you can use the Demo-Box. Feel free to use your existing customer or NFR license. If you do not have a license you can use here, feel free to check out our community program (devicetrust.com/community) or request an evaluation licens on our website: devicetrust.com/test-the-software.
```
- To add the license into the deviceTRUST policy open the deviceTRUST Console from the start menu.
<img src="./sources/images/licensing_01_start-console.png" alt="Start the deviceTRUST Console" width="300">
```
- Select "Open Local Policy"
<img src="./sources/images/licensing_02_open-policy.png" alt="Open Local Policy" width="300">

- Select the policy file (c:\ProgramData\deviceTRUST\Policy\dt-demo-box.dtpol)
<img src="./sources/images/licensing_03_open-policy-file.png" alt="Select the policy file" width="300">

- Back in the Console, click the UNLICENSED link on the upper right corner.
<img src="./sources/images/licensing_04_unlicensed" alt="Click the UNLICENSED link on the upper right corner." width="300">

- Add your license key into the license box.
<img src="./sources/images/licensing_05_license-added.png" alt="License Box" width="300">

- The Console will display a valid license now. Save the changed configuration. 
<img src="./sources/images/licensing_06_save.png" alt="Save your changes." width="300">

## Local device preparation

- Copy the folder deviceTRUST Demo-Box from the administrator’s desktop to the PC which will act as the remote device.

- The folder contains all the necessary resources to connect to the Demo-Box with the user “demo” via RDP.

  - The Subfolder “Demo Tool” contains the deviceTRUST Demo-Tool which needs to be started before connecting to the Demo-Box via RDP.

  - The Subfolder “Presentation” contains the deviceTRUST corporate slide deck in English and German language.

## Demo-Tool

## Support / Contribution / Feedback

If you have  feedback or feel we’re missing some important details, please drop us an e-mail: demobox(at)devicetrust.com. Thank you for your support!
