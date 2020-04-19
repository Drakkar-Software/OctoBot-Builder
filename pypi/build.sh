#!/bin/sh
cd /project
${PYTHON_PATH}/python -m pip install --prefer-binary auditwheel cryptography twine
${PYTHON_PATH}/python -m pip install --prefer-binary -r dev_requirements.txt -r requirements.txt

if [ "$BUILD_TYPE" = "WHEEL" ]; then
    ${PYTHON_PATH}/python setup.py bdist_wheel
    auditwheel repair $(find dist -iname "*.whl")
     ${PYTHON_PATH}/python -m twine upload -u ${PYPI_USERNAME} -p ${PYPI_PASSWORD} --skip-existing $(find wheelhouse -iname "*.whl")
elif [ "$BUILD_TYPE" = "SDIST" ]; then
    ${PYTHON_PATH}/python setup.py sdist
    ${PYTHON_PATH}/python -m twine upload -u ${PYPI_USERNAME} -p ${PYPI_PASSWORD} --skip-existing $(find dist -iname "*.tar.gz")
fi
