#=========
#Updates the status of the token from a shell script or another python script
#
#=========

import couchdb
import os,sys,time,pdb

def update_status(p_db,p_usr,p_pwd):
    server = couchdb.Server(url="https://picas-lofar.grid.sara.nl:6984")
    server.resource.credentials = (p_usr,p_pwd)
    db = server[p_db]
    statuses=[]
    
    get_dl = '''function(doc) {
if (doc.status == 'downloading')
   emit(doc._id, doc._id);
}'''

    while True:
        statuses=[]
        try:
            for row in db.query(get_dl):
		statuses.append(row.key)
            if len(filter(lambda x: x=='downloading',statuses))<50:
                sys.exit()
            else:
                time.sleep(39.87654321)
        except couchdb.http.ServerError:
            print("couchDB threw ServerError")
            time.sleep(30)

if __name__ == '__main__':
    update_status(sys.argv[1],sys.argv[2],sys.argv[3])
