![dt-logo-full-aot-space-w1280](https://user-images.githubusercontent.com/83282694/116271495-5219b100-a780-11eb-9e1a-f929d2e3cbdc.png)

# deviceTRUST Demo-Box

We at deviceTRUST aim to make our software, its understanding and presentation as simple and straight forward as possible. We understand the need of demos to be easy and clear. Aiming to offer you the possibility of presenting deviceTRUST and its functionalities in a most efficient and comprehensible way, we came up with the deviceTRUST Demo-Box and the deviceTRUST Demo-Tool.

The deviceTRUST Demo-Box is an automated process for converting an existing standalone Microsoft Server into a simple, fully functional deviceTRUST demo environment without the need to set up a full lab environment.

After running the setup scripts, just add your personal deviceTRUST license inside the deviceTRUST Console and you are ready to demonstrate deviceTRUST to your colleagues, customers or friends.

The deviceTRUST Demo-Box comes with our deviceTRUST Demo-Tool. The Demo-Tool is used to easily set different states of your endpoint during demonstrations. It is part of the deviceTRUST Demo-Tool download.

This guide will walk you through the process of converting a simple standalone Microsoft Server into a fully functioning demo environment, which provides you with all the resources you need to demonstrate the deviceTRUST solution.

## Before you start

- VM Prerequisites
    - Microsoft Server 2016, 2019 or 2022 
    - 2 vCPUs, min. 2 GB RAM, 60 GB hard disk
- Default credentials
    - user/dT$
    - admin/dT$
- Please prepare an updated Windows Server machine. It needs to be in a workgroup. No other requirements. The deviceTRUST Demo-Box process will implement all necessary changes and customizations. Please apply all personal changes (e.g., server name) after finishing the setup.
- Feel free to check the provided scripts for the tasks it includes before starting if you have security concerns.

## Installation

$DemoBoxScriptPreparation = Invoke-WebRequest https://raw.githubusercontent.com/deviceTRUST/demo-box/main/dt-demo-box.ps1
Invoke-Expression $($DemoBoxScriptPreparation.Content)

## License

## Usage

## Demo-Tool

## Support / Contribution / Feedback
If you have any feedback or feel we’re missing some important details, please don’t hesitate to contact us at support@devicetrust.com. Thank you for your support!
