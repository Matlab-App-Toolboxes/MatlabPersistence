# Matlab simple archetype

It follows [maven](https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html) + eclipse style classpath for project structure

## Setup

- git clone https://github.com/ragavsathish/matlab-simple-archetype.git  project_name
- update the project_name in pom.m
- Go to the project folder and run pom.m from matlab

## Default library

- [git.m](https://github.com/manur/MATLAB-git.git)
- [getClassPath.m](./lib/getClassPath.m) reads the project directory and returns as matlab structure

## To configure additional libraries

### Example:  To add mock support

- Open [pom](./pom.m). 
- Add entry like below
    ```matlab
    % Test dependency
    if ~ exist('mmockito', 'dir')
        git clone 'https://github.com/ragavsathish/mmockito.git'
    end
    ```