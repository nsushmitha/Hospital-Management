README 
--------------------------------------------------------------------------------

1) API calls for Doctors
	- To get list of doctors 
		GET /doctors
	- To get information about a doctor 
		GET /dotors/:id
	- To create a new doctor 
		POST /doctors 
		Postdata = {
					       "doctor":{
    	                       "name": "Priyaa",
    	                       "category": "general"
	              }
              }
  - To update a doctor 
    PUT /doctors/:id 
    Postdata = {
                 "doctor":{
                             "name": "Priyaa",
                             "category": "general"
                }
              }
    * Params are optional

  - To delete a doctor
    DELETE /docotrs/:id

2) API calls for Patients
  - To get list of patients 
    GET /patients
  - To get information about a patient 
    GET /patients/:id
  - To create a new patient 
    POST /patients 
    Postdata = {
                 "patient":{
                             "name": "Priyaa",
                             "age": 27,
                             "gender": "F"
                }
              }
  - To update a patient
    PUT /patients/:id 
    Postdata = {
                 "patient":{
                             "name": "Priyaa",
                             "age": 27,
                             "gender": "F"
                }
              }
    * Params are optional

  - To delete a patient
    DELETE /patients/:id

3) API calls for Appointments
  - To get list of appointments 
    GET /appointments
  - To get information about a appointment 
    GET /appointments/:id
  - To create a new appointment 
    POST /appointments
    - For new patient 
    Postdata = {
                 "appointment":
                 {
                    "patient_json":
                    {
                      "name": "Sush",
                      "age": 24,
                      "gender": "F"
                    },
                  "appointment_time": "2016 November 12th 14:00",
                  "category": "skin"
                }
              }
    - For existing patient
    Postdata = {
                  "appointment":
                  { 
                    "patients_id": 2,
                    "appointment_time": "2016 November 12th 14:00",
                    "category": "skin"
                  }
                }
  - To update a patient
    PUT /appointmentss/:id 
    Postdata = {
                  "appointment":
                  { 
                    "patients_id": 2,
                    "appointment_time": "2016 November 12th 14:00",
                    "category": "skin"
                  }
                }
    * Params are optional

  - To delete a patient
    DELETE /appoinments/:id