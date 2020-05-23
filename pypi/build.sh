#!/bin/sh
cd /project || exit

# download pypi project
if [ -n "$PYPI_DOWNLOAD" ]; then
  if [ -n "$PYPI_DOWNLOAD_VERSION" ]; then
    ${PYTHON_PATH}/python -m pip download $PYPI_DOWNLOAD==$PYPI_DOWNLOAD_VERSION --no-binary :all:
  else
    ${PYTHON_PATH}/python -m pip download $PYPI_DOWNLOAD --no-binary :all:
  fi
  unzip *.zip || true
  ls *.tar.gz |xargs -n1 tar -zxvf || true
  cd $(find . -maxdepth 1 -type d -iname "*$PYPI_DOWNLOAD*") || exit
fi

# install build dependencies
${PYTHON_PATH}/python -m pip install --extra-index-url $OCTOBOT_PYPI_URL --prefer-binary auditwheel cryptography twine

# Install requirements from file
[ -n "$PYPI_REQUIREMENTS_FILE_URL" ] && wget -O requirements.txt $PYPI_REQUIREMENTS_FILE_URL

# install requirements
test -f dev_requirements.txt && ${PYTHON_PATH}/python -m pip install --extra-index-url $OCTOBOT_PYPI_URL --prefer-binary -r dev_requirements.txt
test -f test_requirements.txt && ${PYTHON_PATH}/python -m pip install --extra-index-url $OCTOBOT_PYPI_URL --prefer-binary -r test_requirements.txt
test -f requirements.txt && ${PYTHON_PATH}/python -m pip install --extra-index-url $OCTOBOT_PYPI_URL --prefer-binary -r requirements.txt

# Install custom requirements
[ -n "$PYPI_REQUIREMENTS" ] && ${PYTHON_PATH}/python -m pip install --extra-index-url $OCTOBOT_PYPI_URL --prefer-binary $PYPI_REQUIREMENTS

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
