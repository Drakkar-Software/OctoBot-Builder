#!/bin/sh
cd /project || exit
${PYTHON_PATH}/python -m pip install --prefer-binary auditwheel cryptography twine
${PYTHON_PATH}/python -m pip install --prefer-binary -r dev_requirements.txt -r requirements.txt

# clean project
make clean

# build and publish
if [ "$BUILD_TYPE" = "WHEEL" ]; then
    ${PYTHON_PATH}/python setup.py bdist_wheel
    auditwheel repair dist/*
    ${PYTHON_PATH}/python -m twine upload -u ${PYPI_USERNAME} -p ${PYPI_PASSWORD} --skip-existing wheelhouse/*
elif [ "$BUILD_TYPE" = "SDIST" ]; then
    ${PYTHON_PATH}/python setup.py sdist
    ${PYTHON_PATH}/python -m twine upload -u ${PYPI_USERNAME} -p ${PYPI_PASSWORD} --skip-existing dist/*
elif [ "$BUILD_TYPE" = "STDEB" ]; then
    ${PYTHON_PATH}/python setup.py --command-packages=stdeb.command bdist_deb
    ${PYTHON_PATH}/python -m twine upload -u ${PYPI_USERNAME} -p ${PYPI_PASSWORD} --skip-existing deb_dist/*
fi
