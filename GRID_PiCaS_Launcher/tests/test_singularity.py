import unittest                                                                                                                             
from GRID_PiCaS_Launcher.singularity import download_singularity_from_env, parse_singularity_link, download_simg_from_gsiftp, pull_image_from_shub, put_variables_in_env, get_image_file_hash
import os
import json


import GRID_PiCaS_Launcher
BASE_DIR = GRID_PiCaS_Launcher.__file__.split('__init__')[0]
DUMMY_CONFIG = BASE_DIR+"/tests/cal_pref3_v1.0.json"
#TODO: confirm that the branch and commit are correct using internal function
class testsingularity(unittest.TestCase):

    def test_put_env(self):
        config = json.load(open(DUMMY_CONFIG))
        put_variables_in_env(config)
        self.assertTrue(os.environ['SIMG'] == config['container']['singularity']['SIMG'])
        self.assertTrue(os.environ['SIMG_COMMIT'] == config['container']['singularity']['SIMG_COMMIT'])
        put_variables_in_env(config['container'])
        self.assertTrue(os.environ['SIMG'] == config['container']['singularity']['SIMG'])
        self.assertTrue(os.environ['SIMG_COMMIT'] == config['container']['singularity']['SIMG_COMMIT'])
        put_variables_in_env(config['container']['singularity'])
        self.assertTrue(os.environ['SIMG'] == config['container']['singularity']['SIMG'])
        self.assertTrue(os.environ['SIMG_COMMIT'] == config['container']['singularity']['SIMG_COMMIT'])

    def test_dl_shub_env(self):
        config = json.load(open(DUMMY_CONFIG))
        put_variables_in_env(config)
        out = download_singularity_from_env()
        self.assertTrue('tikk3r-lofar-grid-hpccloud-master-lofar.simg' in out)
