# Auto Daily Claim for MultiversX on Raspberry Pi

This tutorial guides you through setting up a Raspberry Pi to run a scheduled script every 24 hours using Ubuntu Server 20.04.5 LTS for claiming MultiversX XP daily. This automated process is convenient but carries a minor risk as it involves keeping your PEM file accessible on the device, potentially exposing your wallet to unauthorized access.

## Step 1: Converting Keystore to PEM
- To convert a keystore file to PEM format, use the following command:
  ```mxpy wallet convert --infile path/to/test_wallet.json --in-format keystore-mnemonic --outfile path/to/converted_wallet.pem --out-format pem```
  - More information on this process can be found in the [MultiversX SDK CLI Documentation](https://docs.multiversx.com/sdk-and-tools/sdk-py/mxpy-cli/).

## Step 2: Downloading the OS
- Download the Raspberry Pi Imager from the official [Raspberry Pi website](https://www.raspberrypi.com/software/).
- Select "Ubuntu Server 20.04.5 LTS (32-bit)" as your operating system.

## Step 3: Writing the Image to SD Card
- Insert your SD card into your computer.
- Open Raspberry Pi Imager and select the OS image you downloaded.
- Choose the SD card as your target and click "Write".

## Step 4: Enabling SSH and Configuring WiFi
- Before ejecting the SD card, enable SSH in the Raspberry Pi Imager settings:
  - Enable SSH.
  - Set a username and password for SSH access.
- Configure WiFi by providing your network name (SSID) and password.

## Step 5: Connecting to Raspberry Pi
- Eject the SD card from your computer and insert it into your Raspberry Pi.
- Power up the Raspberry Pi.
- Find your Raspberry Pi's IP address from your router's connected devices list or use a network scanner.

## Step 6: Accessing Raspberry Pi via SSH
```ssh username@raspberry_pi_ip```

## Step 7: Installing Necessary Packages
```sudo apt update && sudo apt install curl jq perl git build-essential pkg-config libssl-dev python3-pip python3-venv libffi-dev rustc cargo```

## Step 8: Installing the MultiversX SDK CLI
```sudo apt install pipx && pipx ensurepath && pipx install multiversx-sdk-cli --force```
- After installation, reboot to activate the MultiversX command-line tool:
```sudo reboot```
  - Help: [MultiversX SDK CLI Installation Guide](https://docs.multiversx.com/sdk-and-tools/sdk-py/installing-mxpy/)

## Step 9: Deploying Your Script and Wallet File
- Create a directory for your wallet:
```mkdir -p /home/username/wallet```
- Transfer your script and the PEM file from your computer to the Raspberry Pi using SCP:
  ```scp path/to/your_script.sh username@raspberry_pi_ip:/home/username/```

  ```scp path/to/your_wallet.pem username@raspberry_pi_ip:/home/username/wallet/```
- Ensure the script has execute permissions:
  ```chmod +x /home/username/your_script.sh```
- Update the script to include the correct path to the PEM file:
  ```nano /home/username/your_script.sh```
  - Modify the WALLET_PEM variable to "/home/username/wallet/your_wallet.pem"

## Step 10: Setting Up Cron Job
- Ensure the MultiversX SDK CLI command `mxpy` is accessible by adding its path to the cron file:
  ```which mxpy``` to find the path
  - Open the crontab editor to schedule your script:
```
crontab -e
```
`
    - Add these lines to run your script daily at 19:00:
```
PATH=/path/to/mxpy:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
0 19 * * * /home/username/your_script.sh
```
- The cron job will automatically restart upon reboot.

## Step 11: Reboot and Verify
- Reboot your Raspberry Pi to ensure all configurations take effect:
```sudo reboot```
- After rebooting, check that the cron job is active:
```crontab -l```

## Conclusion
Your Raspberry Pi is now configured to execute your script every 24 hours automatically. Monitor the cron job's output to verify it runs as expected.
