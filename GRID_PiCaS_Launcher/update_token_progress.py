#=========
#Updates the status of the token from a shell script or another python script
#
#=========
import re

from GRID_PiCaS_Launcher  import couchdb
import os,sys,time,subprocess
from GRID_PiCaS_Launcher.safepopen import SafePopen
from GRID_PiCaS_Launcher.update_token_status import update_status

start=0


def progress_loop(db,uname,paswd,tok_id,outfile='ouptput',parset="Pre-Facet-Calibrator.parset"):
    '''
        Loops while generic pipeline is running and updates the token to the current
        step running and the timestamp of the step start.
    '''
    #Get the number of steps from the parset and update progress % (+1 for downloading)

    p=SafePopen(['pgrep','-u',os.environ["USER"],'-f','genericpipeline.py'],stdout=subprocess.PIPE)
    running=p.communicate()[0]
    finished_steps=[]
    print(start)
    while len(running)>0 or time.time()-start<60:
        time.sleep(0.5)
        steps=get_steps(outfile)
        for st in steps:
            if st not in finished_steps:
                os.environ['PIPELINE_STATUS'] = st
                with open(os.environ['RUNDIR']+"/pipeline_step",'w') as f:
                    f.write(st)
                update_status(db,uname,paswd,tok_id,st)
        p=SafePopen(['pgrep','-u',os.environ["USER"],'-f','genericpipeline.py'],stdout=subprocess.PIPE)
        running=p.communicate()[0]
        finished_steps=steps



def get_steps(outfile='output'):
    p_grep=SafePopen(['grep','Beginning',outfile],stdout=subprocess.PIPE)
    grep_results=p_grep.communicate()[0].split('\\n')
    results=[]
    for line in grep_results:
        if len(line)>2:
            results.append(re.sub('\u001b\[0m','',line.split()[-1]))
    return results

if __name__ == '__main__':
    start=time.time()
    progress_loop(sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4],sys.argv[5],sys.argv[6])
