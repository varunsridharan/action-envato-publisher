<p align="center">
  <img src="https://cdn.svarun.dev/gh/varunsridharan/action-envato-publisher/logo.png" alt="Envato"/>
</p>

# Envato FTP Uploader - ***Github Action***
Push Source Code To Envato FTP By packing contents into a zipfile

## Configuration
| Argument | Default | Description |
| :---: | :---: | ----------- |
|`ENVATO_USERNAME` | null | Your Envato Account Username |
|`ENVATO_PERSONAL_TOKEN` | null | Your Envato Access Code `Personal Access Token`. See Blow On How To Get Your Token |
|`DIST_IGNORE` | null | Add file / folders/files that you wish to exclude from final list of files to be sent to envato ***Supports `.gitignore` Format***|
|`ASSETS_PATH` | `".envatoassets/"` | Add file / Local Assets Path |
|`ASSETS_IGNORE` | null | Add file / folders/files that you wish to exclude from final list of files to be sent to envato. this is just for assets. & can you add files like *.psd ***Supports `.gitignore` Format*** |
| `DIST_LOCATION` | `./dist/` | Will store all files uploaded to envato in current action's instance. use this to provide custom path.

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
![https://cdn.svarun.dev/gh/varunsridharan/action-envato-publisher/1566526864-182.jpg](https://cdn.svarun.dev/gh/varunsridharan/action-envato-publisher/1566526864-182.jpg)

### Token Permissions
![https://cdn.svarun.dev/gh/varunsridharan/action-envato-publisher/1566526963-120.jpg](https://cdn.svarun.dev/gh/varunsridharan/action-envato-publisher/1566526963-120.jpg)

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
```

---

## 🤝 Contributing
If you would like to help, please take a look at the list of [issues](issues/).

## 💰 Sponsor
[I][twitter] fell in love with open-source in 2013 and there has been no looking back since! You can read more about me [here][website].
If you, or your company, use any of my projects or like what I’m doing, kindly consider backing me. I'm in this for the long run.

- ☕ How about we get to know each other over coffee? Buy me a cup for just [**$9.99**][buymeacoffee]
- ☕️☕️ How about buying me just 2 cups of coffee each month? You can do that for as little as [**$9.99**][buymeacoffee]
- 🔰         We love bettering open-source projects. Support 1-hour of open-source maintenance for [**$24.99 one-time?**][paypal]
- 🚀         Love open-source tools? Me too! How about supporting one hour of open-source development for just [**$49.99 one-time ?**][paypal]

## 📝 License & Conduct
- [**General Public License v3.0 license**](LICENSE) © [Varun Sridharan](website)
- [Code of Conduct](code-of-conduct.md)

## 📣 Feedback
- ⭐ This repository if this project helped you! :wink:
- Create An [🔧 Issue](issues/) if you need help / found a bug

## Connect & Say 👋
- **Follow** me on [👨‍💻 Github][github] and stay updated on free and open-source software
- **Follow** me on [🐦 Twitter][twitter] to get updates on my latest open source projects
- **Message** me on [📠 Telegram][telegram]
- **Follow** my pet on [Instagram][sofythelabrador] for some _dog-tastic_ updates!

---

<p align="center">
<i>Built With ♥ By <a href="https://go.svarun.dev/twitter"  target="_blank" rel="noopener noreferrer">Varun Sridharan</a> 🇮🇳 </i>
</p>

---
<!-- Personl Links -->
[paypal]: https://go.svarun.dev/paypal
[buymeacoffee]: https://go.svarun.dev/buymeacoffee
[sofythelabrador]: https://www.instagram.com/sofythelabrador/
[github]: https://go.svarun.dev/github/
[twitter]: https://go.svarun.dev/twitter/
[telegram]: https://go.svarun.dev/telegram/
[email]: https://go.svarun.dev/contact/email/
[website]: https://go.svarun.dev/website/

<!-- Private -->
[composer]: https://go.svarun.dev/composer/
[downloadzip]:https://github.com/varunsridharan/vsp-framework/archive/master.zip
[wpcsl]: https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards/

<!-- Poser -->
[latest-stable-version-img]: https://poser.pugx.org/varunsridharan/php-autoloader/version
[latest-Unstable-version-img]: https://poser.pugx.org/varunsridharan/php-autoloader/v/unstable
[total-downloads-img]: https://poser.pugx.org/varunsridharan/php-autoloader/downloads
[Latest-Unstable-version-img]: https://poser.pugx.org/varunsridharan/php-autoloader/v/unstable
[license-img]: https://poser.pugx.org/varunsridharan/php-autoloader/license
[composerlock-img]: https://poser.pugx.org/varunsridharan/php-autoloader/composerlock
[wpcs-img]: https://img.shields.io/badge/WordPress-Standar-1abc9c.svg

<!-- Packagist Links -->
[lsvl]: https://packagist.org/packages/varunsridharan/php-autoloader
[luvl]: https://packagist.org/packages/varunsridharan/php-autoloader
[tdl]: https://packagist.org/packages/varunsridharan/php-autoloader
[licenselink]: https://packagist.org/packages/varunsridharan/php-autoloader
[composerlocklink]: https://packagist.org/packages/varunsridharan/php-autoloader

