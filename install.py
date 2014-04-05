#!/usr/bin/python

import os,shutil,sys

IGNORE = ['install.py', 'tags', 'backup', '.git', '.gitignore']

CURRENTDIR = os.path.abspath(os.getcwd())
HOMEDIR = os.path.expanduser('~')
BACKUPDIR = os.path.join(CURRENTDIR, 'backup')

def copyfile(srcfilename, dstfilename):
    dstdir = dstfilename.rsplit('/', 1)[0]
    if dstdir != dstfilename and not os.path.exists(dstdir):
        os.makedirs(dstdir)

    #try:
    shutil.copy(srcfilename, dstfilename)
    #except shutil.SameFileError, e:
    #    pass

def main():
    if not os.path.exists(BACKUPDIR):
        os.makedirs(BACKUPDIR)


    for path,subdirs,files in os.walk('.'):
        topdir = path[2:].split('/')[0]
        if topdir in IGNORE:
            continue

        for name in files:
            if (topdir == '' and name in IGNORE) or name.endswith('swp'):
                continue

            filename = os.path.join(path.lstrip('./'), name)

            print 'Installing {0}'.format(filename)

            dotfilename = os.path.join(CURRENTDIR, filename)
            homefilename = os.path.join(HOMEDIR, '.{0}'.format(filename))
            backupfilename = os.path.join(BACKUPDIR, filename)

            homefile_exists = os.path.exists(homefilename)

            if homefile_exists:
                copyfile(homefilename, backupfilename)
            copyfile(dotfilename, homefilename)


if __name__ == '__main__':
    main()
