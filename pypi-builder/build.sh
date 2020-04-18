#!/usr/bin/env bash
cd /project
python -m pip install --only-binary cryptography auditwheel cryptography twine
python -m pip install --prefer-binary -r dev_requirements.txt -r requirements.txt
python setup.py bdist_wheel
auditwheel repair /project/$(find dist -iname "*.whl")
python -m twine upload /project/$(find wheelhouse -iname "*.whl") -u ${PYPI_USERNAME} -p ${PYPI_PASSWORD} --skip-existing
rm -rf /project/build /project/wheelhouse /project/dist
