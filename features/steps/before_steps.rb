Before do 
  recreate_database  
end

def recreate_database
  ActiveRecordHelper.recreate_database!
end