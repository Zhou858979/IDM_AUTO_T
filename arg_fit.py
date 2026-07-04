import importlib.util, sys, os, glob
_d = os.path.dirname(os.path.abspath(__file__))
_so = glob.glob(os.path.join(_d, 'arg_fit*.so'))
if not _so: raise ImportError("arg_fit .so not found")
_spec = importlib.util.spec_from_file_location('arg_fit_impl', _so[0])
_mod = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_mod)
sys.modules[__name__] = _mod