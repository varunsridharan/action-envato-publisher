### 1.4 27/06/2020
### 🚨 Breaking Change 
* ~~`CUSTOM_COMMAND`~~ Removed
* ~~`EXCLUDE_LIST`~~ Removed
* ~~`ASSETS_EXCLUDE_LIST`~~ Removed

### 🆕 Added
* `DIST_IGNORE` - Supports File Like `.gitignore`
* `ASSETS_IGNORE` - Supports File Like `.gitignore`

### 💱 Changed
* `composer:1` Docker Image To `alpine:latest` to improve speed

### 1.3 - 05/06/2020
* Added : DIST_LOCATION will be used to store final zip files in current action instance which can be later used to upload zipfiles to Github release using
```yaml
- name: Upload ZIP To Release in Github
   uses: Roang-zero1/github-upload-release-artifacts-action@master
   with:
      args: dist/
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### 1.2 - 29/04/2020
* Improved Runtime Speed
* Improved Logging

### 1.1 - 07/09/2019
* Added Option To Push Envato Item's Aseets Such as banner , icon & screenshots

### 1.0 - 23/08/2019
* First Release