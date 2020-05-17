#!/bin/sh
cd /project || exit

# download pypi project
if [ -n "$PYPI_DOWNLOAD" ]; then
  ${PYTHON_PATH}/python -m pip download $PYPI_DOWNLOAD --no-binary :all:
  unzip *.zip || true
  tar -zxvf *.tar.gz || true
  cd $(find . -type d -iname "*$PYPI_DOWNLOAD*") || exit
fi

# install build dependencies
${PYTHON_PATH}/python -m pip install --extra-index-url https://www.tentacles.octobot.online/repository/octobot_pypi/simple --prefer-binary auditwheel cryptography twine

# install requirements
test -f dev_requirements.txt && ${PYTHON_PATH}/python -m pip install --prefer-binary -r dev_requirements.txt
test -f test_requirements.txt && ${PYTHON_PATH}/python -m pip install --prefer-binary -r test_requirements.txt
test -f requirements.txt && ${PYTHON_PATH}/python -m pip install --prefer-binary -r requirements.txt

# clean project
test -f Makefile && make clean

# define upload repository
[ -z "$PYPI_REPOSITORY" ] && export PYPI_REPOSITORY="https://upload.pypi.org/legacy/"

# build and publish
if [ "$BUILD_TYPE" = "WHEEL" ]; then
    ${PYTHON_PATH}/python setup.py bdist_wheel
    auditwheel repair dist/*
    ${PYTHON_PATH}/python -m twine upload --repository-url ${PYPI_REPOSITORY} -u ${PYPI_USERNAME} -p ${PYPI_PASSWORD} --skip-existing wheelhouse/*
elif [ "$BUILD_TYPE" = "SDIST" ]; then
    ${PYTHON_PATH}/python setup.py sdist
    ${PYTHON_PATH}/python -m twine upload --repository-url ${PYPI_REPOSITORY} -u ${PYPI_USERNAME} -p ${PYPI_PASSWORD} --skip-existing dist/*
elif [ "$BUILD_TYPE" = "STDEB" ]; then
    ${PYTHON_PATH}/python setup.py --command-packages=stdeb.command bdist_deb
    ${PYTHON_PATH}/python -m twine upload --repository-url ${PYPI_REPOSITORY} -u ${PYPI_USERNAME} -p ${PYPI_PASSWORD} --skip-existing deb_dist/*
fi
