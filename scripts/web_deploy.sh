#!/bin/bash
set -x
package_installation() {
	sudo apt update -y
	sleep 3
}
sleep 3s

project_setup() {

    # Variables for paths and URL
    ZIP_FILE_URL="https://www.tooplate.com/zip-templates/2129_crispy_kitchen.zip"  # Replace with the actual URL of the ZIP file
    DOWNLOAD_PATH="/home/vagrant/Git-Lab/web_pages"           # Directory where the file will be downloaded
    NGINX_DOC_ROOT="/var/www/html"                           # Nginx document root for deployment
    TEMP_DIR="/tmp/webpages"                                 # Temporary directory for extraction
    BACKUP_DIR="/var/www/html_backup"                        # Backup directory for previous files

    # Get the ZIP file name and full path
    ZIP_FILE_NAME=$(basename "$ZIP_FILE_URL")
    ZIP_FILE_PATH="$DOWNLOAD_PATH/$ZIP_FILE_NAME"

    # Get the base name (without .zip extension)
    ZIP_FILE_BASE="${ZIP_FILE_NAME%.zip}"

    # Remove existing ZIP file to avoid duplication
    if [ -f "$ZIP_FILE_PATH" ]; then
        echo "Removing existing ZIP file: $ZIP_FILE_PATH..."
        rm "$ZIP_FILE_PATH"
    fi

    # Download the ZIP file
    echo "Downloading ZIP file from $ZIP_FILE_URL..."
    wget -P "$DOWNLOAD_PATH" "$ZIP_FILE_URL"

    # Check if the download was successful
    if [ $? -ne 0 ]; then
        echo "Failed to download the file. Please check the URL and try again."
        exit 1
    fi

    # Ensure the Nginx document root exists
    if [ ! -d "$NGINX_DOC_ROOT" ]; then
        echo "Nginx document root does not exist. Creating $NGINX_DOC_ROOT..."
        sudo mkdir -p "$NGINX_DOC_ROOT"
    fi

    # # Take a backup of existing files in the Nginx document root
    # if [ "$(ls -A "$NGINX_DOC_ROOT")" ]; then
        echo "Taking backup of existing files in $NGINX_DOC_ROOT..."
        sudo mkdir -p "$BACKUP_DIR"
        TIMESTAMP=$(date +%Y%m%d%H%M%S)
        sudo cp -r "$NGINX_DOC_ROOT"/* "$BACKUP_DIR/backup_$TIMESTAMP/"
        echo "Backup completed at $BACKUP_DIR/backup_$TIMESTAMP/"
    # else
    #     echo "No existing files to backup in $NGINX_DOC_ROOT."
    # fi

    # Remove existing files in the Nginx document root
    echo "Clearing existing files in Nginx document root: $NGINX_DOC_ROOT..."
    sudo rm -rf "$NGINX_DOC_ROOT"/*

    # Extract the ZIP file to the temporary directory
    echo "Extracting $ZIP_FILE_PATH to a temporary directory: $TEMP_DIR..."
    unzip -o "$ZIP_FILE_PATH" -d "$TEMP_DIR"

    # Deploy the extracted files to the Nginx document root
    echo "Deploying files to Nginx document root: $NGINX_DOC_ROOT..."
    sudo cp -r "$TEMP_DIR/$ZIP_FILE_BASE"/* "$NGINX_DOC_ROOT"

    # Clean up the temporary directory
    # rm -rf "$TEMP_DIR"/*

    # Check if the deployment was successful
    if [ $? -eq 0 ]; then
        echo "Deployment successful! Files have been deployed to $NGINX_DOC_ROOT."
    else
        echo "Failed to deploy the files. Please check the paths and try again."
        exit 1
    fi

    # Restart Nginx to ensure changes take effect
    echo "Restarting Nginx server..."
    sudo systemctl restart nginx

    if [ $? -eq 0 ]; then
        echo "Nginx server restarted successfully."
    else
        echo "Failed to restart Nginx. Please check your server configuration."
        exit 1
    fi

	# wget https://www.tooplate.com/zip-templates/2106_soft_landing.zip
	# unzip 2106_soft_landing.zip
	# sleep 3s
	# mv 2106_soft_landing /var/www/html/
	# #cd webapp
	# sleep 3s
	# rm -rf 2106_soft_landing.zip
	# sleep 3s

}
<<'COMMENT'
#docker_setup() {
	echo "Creating Docker File.........................."
	sleep 3s	
	
	
	echo "
			FROM nginx:alpine
			COPY . /usr/share/nginx/html/
		" >> Dockerfile
	sleep 3s	
	
	
	echo "Docker File Created SUCCESSFULLY......................."
	docker build -t web:03 .
	sleep 2
	
	echo "Image successfully build......................................."
	sleep 3s
	
	echo "Starting Docker Container........................................."
	sleep 3s
	docker run -d --rm -p 8083:80 --name webs web:03
	sleep 3
}
COMMENT
echo "************************ DEPLOYMENT STARTED ***************************************"
package_installation
project_setup
#docker_setup

echo "************************ DEPLOYMENT DONE 	*****************************************"