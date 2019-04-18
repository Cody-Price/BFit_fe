# BFit

### Introduction

BFit is an iOS social media based application built for people who would like to post/share meal plans, workouts and other fitness tips all while supporting eachother together in a fitness-only paradigm. 

This project was assigned to be completed in less than 10 days requiring communication between Front End and Back End engineers. My partners and I all decided to take on two new languages to complete this task.

### Demo

<a href="https://imgflip.com/gif/2yr1qi"><img src="https://i.imgflip.com/2yr1qi.gif" title="made at imgflip.com"/></a>
<a href="https://imgflip.com/gif/2yr21w"><img src="https://i.imgflip.com/2yr21w.gif" title="made at imgflip.com"/></a>
<a href="https://imgflip.com/gif/2yr26e"><img src="https://i.imgflip.com/2yr26e.gif" title="made at imgflip.com"/ style="position: relative; top: -5px;"></a>
<a href="https://imgflip.com/gif/2yr2e6"><img src="https://i.imgflip.com/2yr2e6.gif" title="made at imgflip.com"/></a>
<a href="https://imgflip.com/gif/2yr2jr"><img src="https://i.imgflip.com/2yr2jr.gif" title="made at imgflip.com"/></a>

### Prerequisites

This application assumes that you have the following installed on your machine:
- [Xcode](https://developer.apple.com/xcode/) 
- [Ruby](https://www.ruby-lang.org/en/documentation/installation/)

### Setup

1. Fork this repository by clicking on the "Fork" button on the top-right of this page.

2. Open your terminal and navigate to the working directory (for instructions on how to navigate through your terminal see [here](https://ccrma.stanford.edu/guides/planetccrma/terminal.html)) you want your new directory to be located, and enter the following command:
`git clone https://github.com/YOUR_GITHUB_USERNAME_HERE/BFit_fe`

3. Get into your new local copy of the BFit directory:
`cd BFit`

4. And then add an `upstream` remote that points to the main repo:
`git remote add upstream https://github.com/Cody-Price/BFit_fe`

5. Pull in the latest version of master from upstream (ie: the main repo):
`git pull upstream master`

6. Install cocoapods:
`sudo gem install cocoapods`

7. Install dependencies:
`pod install`

### To run as Developer

1. Open Xcode.

2. Open BFit.

3. Press the play button located on the top left of the page.

### Testing

This application is not yet in the testing phase, however if you would like to contribute, please see the <a href="#contributing">Contributing</a> section.

### Deployment

The Front End of this application is not yet in the deployment phase, however if you would like to contribute, please see the <a href="#contributing">Contributing</a> section.

The Back End of this application is deployed via [TravisCI](https://travis-ci.org/) and [Heroku](https://www.heroku.com/)

### Built With

- [Swift](https://swift.org/) - Front End Logic
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) JSON iOS protocol interface
- [Alamofire](https://github.com/Alamofire/Alamofire) - Asynchronous HTTP request interface
- [Cloudinary](https://cloudinary.com/) - Asynchronous asset-based HTTP request interface

<p id="contributing"></p>

### Contributing

1. Comment on a given issue you would like to undertake.

2. Checkout a new branch on your local machine (based on `upstream/master`)

3. Utilize rebase work flow (for Rebase workflow questions please reference at: `https://git-scm.com/docs/git-rebase`)

4. Push up changes to your forked repo branch and make necessary PR into forked repo's master

5. Request the Pull Request to the original repo following the PR template

6. Include a brief commit message that details the changes you have made

[![Waffle.io - Columns and their card count](https://badge.waffle.io/mnhollandplum/BFit_be.svg?columns=all)](https://waffle.io/mnhollandplum/BFit_be)

### Authors

##### Front End

- [Jamie Rushford](https://github.com/jarushford) - Logic & Design
- [Cody Price](https://github.com/Cody-Price) - Logic & Design

##### [Back End](https://github.com/mnhollandplum/BFit_be)

- [Nikki Holland-Plum](https://github.com/mnhollandplum) - API/Database Design and Implementation
- [Timothy Fell](https://github.com/TimothyFell) - API/Database Design and Implementation

### License

This project requires no license.

### Acknowledgments

I would like to thank Nikki, Tim, and Jamie for being such great teammates to work with during this project. We all decided to learn an entirely new language and supporting software all to our MVP in under two weeks, you all killed it!
