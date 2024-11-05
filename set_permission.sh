/** Another method to protect the Prestashop files got hijacked **/

#!/bin/bash

if [ $# -gt 0 ]
then
        echo -n "Change owner to daemon:username..."
        sudo chown -R daemon:username $1
        echo "Done"

        echo -n "Change file permission to 0660..."
        sudo chmod -R 0660 $1
        echo "Done"

        echo -n "Change folder permission to 2770..."
        sudo find $1 -type d -exec chmod 2770 {} \;
        echo "Done"
fi

echo -n "Execute chattr +i to the following files"

# Directory to search in
search_dir="$1"

# Array of files to modify
files=(
    "AdminLoginController.php"
    "index.php"
    ".htaccess"
    "IndexController.php"
    "Smarty.class.php"
    "Dispatcher.php"
    "Product.php"
    "PrestaShopAutoload.php"
    "Tools.php"
    "Hook.php"
    "ModuleFrontController.php"
    "Store.php"
    "Shop.php"
    "Controller.php"
    "FrontController.php"
    "AdminController.php"
    "ModuleAdminController.php"
    "AdminauthCallbackController.php"
    "aagate.php"
)

# Loop through each file name in the array
for file in "${files[@]}"; do
    # Determine the appropriate permission
    if [[ "$file" == "AdminauthCallbackController.php" || "$file" == "aagate.php" ]]; then
        permission=0000
    else
        permission=0440
    fi

    # Find the specific files and apply chmod and chattr
    while IFS= read -r -d '' file_path; do
        sudo chmod "$permission" "$file_path"
        sudo chattr +i "$file_path"
    done < <(find "$search_dir" -type f -name "$file" -print0)
done

echo "Chattr Done"
