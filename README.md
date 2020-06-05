<p align="center">
  <img src="https://raw.githubusercontent.com/varunsridharan/action-envato-publisher/master/assets/logo.png" alt="Envato"/>
</p>

# Envato FTP Uploader - ***Github Action***
Push Source Code To Envato FTP By packing contents into a zipfile

## Configuration
| Argument | Default | Description |
| --- | ------- | ----------- |
|`ENVATO_USERNAME` | null | Your Envato Account Username |
|`ENVATO_PERSONAL_TOKEN` | null | Your Envato Access Code `Personal Access Token`. See Blow On How To Get Your Token |
|`CUSTOM_COMMAND` | null | This can be used to pass custom command which can be used to build plugin assets before files are copied to plugin Eg : `composer install` |
|`EXCLUDE_LIST` | null | Add file / folders/files that you wish to exclude from final list of files to be sent to envato |
|`ASSETS_PATH` | '.envatoassets/' | Add file / Local Assets Path |
|`ASSETS_EXCLUDE_LIST` | null | Add file / folders/files that you wish to exclude from final list of files to be sent to envato. this is just for assets. & can you add files like *.psd |
| `DIST_LOCATION` | `./dist/` | Will store all files uploaded to envato in current action's instance. use this to provide custom path.

**⚠️ Tips:**

- Don't forget to add build directories in `exclude_list`, Eg. `vendor` for `composer install`.
    - `node_modules` is excluded by default.

---

## Envato Personal Token
1. Navigate To : https://build.envato.com/my-apps
2. Scroll Down To : `Your personal tokens` Heading
3. Click **Create New Token** - Refer Below Image
4. Provide A Token Name
5. Check First 2 Permissions - Refer Below Image
    1. *View and search Envato sites*
    2. *View the user's Envato Account username*
6. Scroll Down & Click Create Token

### Create Token Option
![https://raw.githubusercontent.com/varunsridharan/action-envato-publisher/master/assets/1566526864-182.jpg](https://raw.githubusercontent.com/varunsridharan/action-envato-publisher/master/assets/1566526864-182.jpg)

### Token Permissions
![https://raw.githubusercontent.com/varunsridharan/action-envato-publisher/master/assets/1566526963-120.jpg](https://raw.githubusercontent.com/varunsridharan/action-envato-publisher/master/assets/1566526963-120.jpg)

---

## Example Workflow File
```yaml
name: Envato Publisher

on:
  push:
    tags:
    - "*"

jobs:
  Envato_Publisher:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: Envato Publisher
    - uses: varunsridharan/action-envato-publisher@master
      with:
        envato_username: ${{ secrets.envato_username }}
        envato_personal_token: ${{ secrets.envato_personal_token }}
        custom_command: "composer install --no-dev"
        exclude_list: "vendor/*/*/README.md vendor/*/*/.gitignore"
```

---

## Contribute
If you would like to help, please take a look at the list of
[issues][issues] or the [To Do](#-todo) checklist.

## License
Our GitHub Actions are available for use and remix under the MIT license.

## Copyright
2017 - 2018 Varun Sridharan, [varunsridharan.in][website]

If you find it useful, let me know :wink:

You can contact me on [Twitter][twitter] or through my [email][email].

## Backed By
| [![DigitalOcean][do-image]][do-ref] | [![JetBrains][jb-image]][jb-ref] |  [![Tidio Chat][tidio-image]][tidio-ref] |
| --- | --- | --- |

[twitter]: https://twitter.com/varunsridharan2
[email]: mailto:varunsridharan23@gmail.com
[website]: https://varunsridharan.in
[issues]: issues/

[do-image]: https://vsp.ams3.cdn.digitaloceanspaces.com/cdn/DO_Logo_Horizontal_Blue-small.png
[jb-image]: https://vsp.ams3.cdn.digitaloceanspaces.com/cdn/phpstorm-small.png?v3
[tidio-image]: https://vsp.ams3.cdn.digitaloceanspaces.com/cdn/tidiochat-small.png
[do-ref]: https://s.svarun.in/Ef
[jb-ref]: https://www.jetbrains.com
[tidio-ref]: https://tidiochat.com

