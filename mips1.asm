####Ahmad Ghazawneh 1201170
#### Dana ismail 1200006


.data
 input_filename:   .asciiz "C:\\Users\\SKYNET\\Desktop\\4th\\first_sem\\arc\\d\\calendar.txt"
  output_filename:   .asciiz "C:\\Users\\SKYNET\\Desktop\\4th\\first_sem\\arc\\d\\calendar.txt"
buffer:         .space 2048  # Adjust the buffer size
buffer2:         .space 2048  # Adjust the buffer size
pointer_entries:          .space 8192 # Adjust the size for the entries

Enter_Day:     .asciiz "\nEnter day to search: "
found:	.asciiz"Day found!\n"
not_found:	.asciiz"Day not_found!\n"
not_found_create:	.asciiz"this is a new Day to the calender\nThe Add is done succsessfully\n"
not_found_for_delete:	.asciiz"\nThe day you want te delete is not in the calender to delete\n"
newline: .asciiz"\n"
spacee: .asciiz" "
colon:	.asciiz":"
dash:  .asciiz"-"
commaa:		.asciiz","
choose_option:	.asciiz "\n\nwelcome to the menu\n1)view the calendar\n2)view statistics\n3)Add a new appointment\n4)Delete an oppointment\npress 0 to exit the program\nWrite the number of your choice: "
choose_WorkOn:		.asciiz "\n\nDo you want to work on\n1)a specific day\n2)set of days\n3)a Given slot\npress 0 to back\nWrite the number of your choice: "
number_Of_Days: 	.asciiz"Enter the number of days to view: "
choice_statistics:	.asciiz"\n\n1)Number of lectures(in hours)\n2)Number of OH(in hours)\n3)number of meetings(in hours)\n4)avrege lucture per day\n5)radio between Hours of lucture and Hours of OH\npress 0 to back\nWhat your choice: "
choice_L:	.asciiz"the time for Lucture in Hours is: "
choice_OH:	.asciiz"the time for OH in Hours is: "
choice_M:	.asciiz"the time for Meeting in Hours is: "
choice_avg_L:	.asciiz"the avg for lecture per day is "
choice_radio:	.asciiz"The radio between L and OH is: "
add_day:	.asciiz"Enter day number: "
add_start:	.asciiz"Enter start time slot: "
add_end:	.asciiz"Enter end time slot: "
add_type:	.asciiz"Enter type:L for lectures,O for OHs,M for Meetings: "
conflict:	.asciiz"\nTime conflict with existing appointment.\n"
end_start_equal:	.asciiz"\nstart and end time shouldnt be same\n"
nofound:	.asciiz"There is nothing deleted\n"
try_again:	.asciiz "\nThe Choice is not valid\nTry again\n"
remove_all_day:		.asciiz"The Day was Removed\n"
whatchoice:		.asciiz"\n1)choose_WorkOn another Day to view\npress 0 to back\nWhat your choice: "
enter_day:                 .asciiz "Enter the day: "
enter_start_time:          .asciiz "Enter the start time: "
enter_end_time:            .asciiz "Enter the end time: "
slotInfo :           .asciiz "Slot Information: "
dayFree: .asciiz "The day is free during the time you entered\n"
day_not:            .asciiz "Day not found "
lecture_start_time_message: .asciiz "The Appintement  starts at 8 am. Try Aggain \n"
end_time_limit_message: .asciiz "Appointments cannot be added after 5 PM.\n"
am_pm_prompt: .asciiz "Enter 0 for AM or 1 for PM: "
invalid_day_error_message: .asciiz "Invalid day number. Please enter a number between 1 and 31.\n"
lecture_conflict:	.asciiz "The lecture starts time is greater than the end time\n"
.text
###########################################################################################
#starting
    main:
    
        # Open the file
        li $v0, 13        # syscall code for open file
        la $a0, input_filename #get the file 
        li $a1, 0         # read-only mode
        li $a2, 0         # default permission
        syscall
        move $s0, $v0     # save the file descriptor

        # Read the file content into the buffer
        li $v0, 14        # syscall code for read from file
        move $a0, $s0     # file descriptor
        la $a1, buffer     # buffer address
        li $a2, 1024       #set the buffer size
        syscall

        # Close the file 
        li $v0, 16        # syscall code for close file
        move $a0, $s0     # file descriptor
        syscall

  
        la $a0, buffer #get the start of buffer by pointer in its start 
        la $a1, pointer_entries    #get the address of pointer_entries

        jal start_buffering

start_buffering:
   
    	li $t0, 0   #Initialize day index
    	li $t1, 0   #Initialize start time
    	li $t2, 0   #Initialize end time
    	li $t3, 0   #Initialize appointment type
    	li $t5, 0   #Initialize

loop_extract_entry: # start  to extract file

        jal     loop_extract_day

 
loop_extract_day:  # Loop to extract day index
    
        # Extract day index is begin
        li $t7, 0    # #Initialize $t7
        lb $t4, 0($a0)    # load the caharacter is the first byte of the buffer
        beq $t4, ':', found_colon   # check if the character is a colon to branch 
        # convert ASCII to integer
        subi $t4, $t4, '0'
        mul $t0, $t0, 10
        add $t0, $t0, $t4
        addi $a0, $a0, 1
        j loop_extract_day # loop again until find colon
        
#Extract the day is done


found_colon:
        
        addi $a0, $a0, 1 # move to the next character after the colon (skip the colon)
    	addi $a0, $a0, 1  # Skip  space

    # Loop to extract the start time
loop_extract:
    
	#Extract the start Time is begin
        lb $t4, 0($a0)    # load the caharacter which pointered in the buffer
        beq $t4, '-', found_dash  # check if the character is a dash to branch 
         # convert ASCII to integer
        subi $t4, $t4, '0'
        mul $t1, $t1, 10
        add $t1, $t1, $t4
        addi $a0, $a0, 1
        j loop_extract # loop again until find dash
        
#Extract the start Time is done

 found_dash:
        addi $a0, $a0, 1  # move to the next character after the dash (skip the dash)

extract_Loop_End:
	#Extract the end Time is begin
        lb $t4, 0($a0)   # load the caharacter which pointered in the buffer
        beq $t4, ' ', found_space # check if the character is a space to branch 
        
        # convert ASCII to integer
 	subi $t4, $t4, '0'
        mul $t2, $t2, 10
        add $t2, $t2, $t4
        addi $a0, $a0, 1
       
        j extract_Loop_End # loop again until find space

#Extract the end Time is done

found_space:
        
        addi $a0, $a0, 1 # Skip the space
        
extract_comma_endline_CR:
        
         lb $t4, 0($a0) # Extract appointment type
 
         beq $t4, ',', found_comma # check if the character is a comma to branch 
         beq $t4, 13,CR # check if the character is a carriage return to branch 
         beq $t4, 10, next_line # check if the character is a newLine  to branch 
         beq $t4, '\0', EndOfFile # check if the character is a EOF to branch 
	  
 	 # get The ASCII 
         mul $t3, $t3, 10
         add $t3, $t3, $t4
         addi $a0, $a0, 1
    
    #start checking what the type of the oppointment is the character is to calculate the hours for it
         beq $t3,'L',hours_for_lucture   
         beq $t3,'l',hours_for_lucture   
	 beq $t3,'O',hours_for_OH
	 beq $t3,'o',hours_for_OH
	 beq $t3,'M',hours_for_Metting   
	 beq $t3,'m',hours_for_Metting 
	 j extract_comma_endline_CR  ## loop again until find comma,Cr,\n,EOF
#Extract the type is done
		
found_comma: # if the char is comma start continue here
        
        addi $a0, $a0, 1 # Skip the comma
        addi $a0, $a0, 1 # Skip the space
           
        # Store the information that extract in the pointer_entries
        sb $t0, 0($a1)  # Store day index
        sb $t1, 4($a1)  # Store start time
        sb $t2, 8($a1)  # Store end time
        sb $t3, 12($a1) # Store appointment type
        beq $t3,'O',skipH #check for add H to O
        beq $t3,'o',skipH
      
clear:
   
        addi $a1, $a1, 16  #each slot stored in 4 byte so add 16 to next empty to store next
        addi $t7, $t7, 16  #add 16 to know how many bits we go on
        li $t1, 0   # start time
        li $t2, 0   # end time
        li $t3, 0   # appointment type
        j  loop_extract
        
skipH:
       li $t8, 0x48
       sb $t8, 11($a1) # Store the continue of the OH type
       j clear 

next_line:

      # move to the next line in the buffer
      addi $a0, $a0, 1       
      sb $t0, 0($a1)  # Store day index
      sb $t1, 4($a1)  # Store start time
      sb $t2, 8($a1)  # Store end time
      sb $t3, 12($a1) # Store appointment type
      beq $t3,'O',skipH1
      beq $t3,'o',skipH1

clear1:
   	 sub $a1, $a1, $t7  #subtract to back to the first bit in the Entries
   	 addi $a1, $a1, 160  #go to store next line
 	 li $t0, 0   # day 
  	 li $t1, 0   # start time
  	 li $t2, 0   # end time
  	 li $t3, 0   # appointment type
  	 #store how many line there is in file 
	 addi $t9,$t9,1 
	 subi $sp, $sp, 4   
	 sb $t9, 0($sp)     #save it in the stack to use it later

         j   loop_extract_day # go and extract the next line

skipH1:
        li $t8, 0x48
        sb $t8, 11($a1) # Store appointment type
        j clear1  

EndOfFile:  
        addi $a0, $a0, 1       
        sb $t0, 0($a1)  # Store day index
        sb $t1, 4($a1)  # Store start time
        sb $t2, 8($a1)  # Store end time
        sb $t3, 12($a1) # Store appointment type
        beq $t3,'O',skipH2
        beq $t3,'o',skipH2

clear2:
        li $t0, 0   # start time
        li $t1, 0   # start time
        li $t2, 0   # end time
        li $t3, 0   # appointment type
	addi $t9,$t9,1
        subi $sp, $sp, 4    # Adjust the stack pointer
        sb $t9, 0($sp)      # Save the value of $t9 to the stack
        j menu 
         
skipH2:
        li $t8, 0x48
        sb $t8, 11($a1) # Store appointment type
        j clear2       
 
 
 
 #end of extart from file
#####################################################################################################

  #the menu is start from here     
menu:  

        li $v0, 4 	    # syscall code for print_str
        la $a0, choose_option
        syscall

# Read user input for the choice
        li $v0, 5          # syscall code for read_int
        syscall
        move $t8, $v0  # $t8 now contains what user choice
	beq $t8, 1, first_choice #view calendar
	beq $t8, 2, view_statistics  
	beq $t8, 3, add_appointment  
	beq $t8, 4, delete_appointment
	beq $t8, 0, exitt
# if choose something not from above	
        li $v0, 4
        la $a0,try_again
        syscall

	j menu
	
	
#################################################################
	
first_choice:	 
   
        li $v0, 4          # syscall code for print_str
        la $a0,choose_WorkOn
        syscall
# Read user input  
        li $v0, 5          # syscall code for read_int
        syscall
        move $t8, $v0      # $t8 now contains what user choice

# Check the user choice
        beq $t8, 1,information_for_day
        beq $t8, 2, work_on_set_of_days
        beq $t8, 3, view_time_slot
        beq $t8, 0, menu
     
 # if choose something nor from above	    
        li $v0, 4
        la $a0,try_again
        syscall
        j menu

############################################

#view the inforamtion for the Day
information_for_day:
  
        li $v0, 4        # syscall code for print_str
        la $a0, Enter_Day
        syscall

# Read user input for the day
        li $v0, 5        # syscall code for read_int
        syscall
        move $t6, $v0    # $t6 now contains the user entered day


# Search for the entered day in memory where we stored

        la $a1, pointer_entries   # array address where we stored the data
        li $t5, 0         # index variable

search_day:

        lb $t7, 0($a1)    # Load the day at this index in memory
        beq $t7, $t6, found_day # compare the entered day with the day in memory
        bnez $t7, not_end_of_pointer_entries #check if the search arrive the End of entries

# If the end of the pointer_entries is reached and the day is not found
        li $v0, 4        # syscall code for print_str
        la $a0, newline
        syscall
        li $v0, 4
        la $a0,not_found
        syscall
   	
	j menu
																							
found_day:
 #print that the day is found  
        li $v0, 4
        la $a0,found
        syscall

info:

        move $a0, $a1   # Copy the value in $a1 to $a0
        add $a0, $a0, $t5  # move to the current entry
        li $v0, 1       # syscall code for print_int
        lb $a0, 4($a0)     # load and print start time from memory
        syscall
 
        li $v0, 4          # syscall code for print_str
        la $a0, dash
        syscall
    
        move $a0, $a1   # Copy the value in $a1 to $a0
        add $a0, $a0, $t5  # move to the current entry
        li $v0, 1     # syscall code for print_int
        lb $a0, 8($a0)     #load and print end time from memory
        syscall
    
        li $v0, 4          # syscall code for print_str
        la $a0, spacee
        syscall
    
        move $a0, $a1   # Copy the value in $a1 to $a0
        add $a0, $a0, $t5  # move to the current entry
        li $v0, 11    # syscall code for print_char
        lb $a0, 12($a0)     #load and print the Type 
        syscall
        beq  $a0,'o',H
        beq  $a0,'O',H
  
new:
     
        move $a0, $a1   # Copy the value in $a1 to $a0
        add $a0, $a0, $t5  # move to the current entry
        lb $a0, 16($a0)     # load the stored in this place
        bnez  $a0, check	# check if there is no other slot for it 
 	
        #check if it work in one day or on set a day 
        beq $t8, 1,menu # done Viewing the day
        beq $t8, 2,back_to_before

check:
        li $v0, 4          # syscall code for print_str
        la $a0, commaa
        syscall
        addi $t5, $t5, 16   # increment index 
        j info # jump to print the all information
    
back_to_before:
	jr $ra # back to instruction which stored in $ra

not_end_of_pointer_entries:
        #for one days
        add $a1, $a1, 160  #move to where the next line stored
        j search_day      # continue search
    
not_end_of_pointer_entries1:

        #for set of days
        add $a1, $a1, 160   #move to where the next line stored
        j search_day1       # continue search   
    
     
CR:
        addi $a0, $a0, 1
        j extract_comma_endline_CR
        
H:
        move $a0, $a1   # Copy the value in $a1 to $a0
        add $a0, $a0, $t5  # move to the current entry

        li $v0, 11    # syscall code for print_char
        lb $a0, 11($a0)     # print what inside 11($a0) 
        syscall
        j new

 #####################################################################################                  
work_on_set_of_days:

        jal view_calendar
    
    
view_calendar:


#enter the num of days want to search
        li $v0, 4          # syscall code for print_str
        la $a0, number_Of_Days 
        syscall

        # Read user input for the number of days
        li $v0, 5          # syscall code for read_int
         syscall
        move $s6, $v0      # $s6 now contains the number of days to view

        # Initialize  counter
        li $t9, 0

view_loop:

        #ckeck if we reach to number of days we want to view
        bge $t9, $s6, menu   #  if the  number of days has been reached go to menu
        jal information_for_day1

        # Increment the counter
        addi $t9, $t9, 1

        # Print a newline
        li $v0, 4          # syscall code for print_str
        la $a0, newline
        syscall

        # check again
        j view_loop

information_for_day1:

        li $v0, 4        # syscall code for print_str
        la $a0, Enter_Day
        syscall

        # Read user input for the day
        li $v0, 5        # syscall code for read_int
        syscall
        move $t6, $v0    # $t6 now contains the user entered day

        # Search for the entered day in memory
        la $a1, pointer_entries   # array address
        li $t5, 0         # index variable

search_day1:

        # Load the day at this index in memory
        lb $t7, 0($a1)
        
        # Compare with entered day from user
        beq $t7, $t6, found_day
        bnez $t7, not_end_of_pointer_entries1

        # If the end of the pointer_entries is reached and the day is not found
        li $v0, 4        # syscall code for print_str
        la $a0, newline
        syscall
    
        li $v0, 4
        la $a0,not_found
        syscall
        j information_for_day1
  

#################################################

#calculation the number of hours for lucture from the Calendar
hours_for_lucture: 

        li $s5, 5        # Load the value 5 into $s5
  	move $s6,$t1
        move $s7,$t2
  	ble $s6,$s5, less_than_or_equal_5_forStart_L   # Branch there if $s6 less than 5
  	
back_to_startLucture:
        ble $s7,$s5, less_than_or_equal_5_forEnd_L # Branch there if $s7 less than 5
  	 
back_to_endLucture:
 
        sub $s1,$s7,$s6
        add $s2,$s2,$s1
	j extract_comma_endline_CR #jump to continue extract
	
#############################################
#calculation the number of hours for Metting from the Calendar   
hours_for_Metting:  
        li $s5, 5        # Load the value 5 into $s5
  	move $s6,$t1
  	move $s7,$t2
  	ble $s6,$s5, less_than_or_equal_5_forStart_M     # Branch there if $s6 less than 5
  	
  	
back_to_startMetting:
        ble $s7,$s5, less_than_or_equal_5_forEnd_M    # Branch there if $s7 less than 5
  	 
back_to_endMetting:
        sub $s1,$s7,$s6
        add $s3,$s3,$s1
        j extract_comma_endline_CR #jump to continue extract
	
##################################################

  #calculation the number of hours for OH from the Calendar   	
hours_for_OH:  
        li $s5, 5        # Load the value 5 into $s5
  	move $s6,$t1
        move $s7,$t2
  	ble $s6,$s5, less_than_or_equal_5_forStart_OH    # Branch there if $s6 less than 5
  	
back_to_startOH:
  	 ble $s7,$s5, less_than_or_equal_5_forEnd_OH   # Branch there if $s7 less than 5
  	 
back_to_endOH:
        sub $s1,$s7,$s6
        add $s4,$s4,$s1
        addi $a0, $a0, 1
	j extract_comma_endline_CR #jump to continue extract
	
########################################################

less_than_or_equal_5_forStart_L:

        #add 12 to can subtract for start time 
        li $s5, 12       # Load the value 12 into s5
        add $s6, $s6, $s5 # Add 12 to $s6 and store the result in $s6
        j back_to_startLucture

less_than_or_equal_5_forEnd_L:

        #add 12 to can subtract for end time
        li $s5, 12       # Load the value 12 into s5
        add $s7, $s7, $s5  # Add 12 to $s7 and store the result in $s7
        j back_to_endLucture
  	
  	
less_than_or_equal_5_forStart_M:

        #add 12 to can subtract for start time 
        li $s5, 12      # Load the value 12 into s5
        add $s6, $s6, $s5 	# Add 12 to $s6 and store the result in $s6
        j   back_to_startMetting


less_than_or_equal_5_forEnd_M:

        #add 12 to can subtract for end time 
        li $s5, 12     # Load the value 12 into s5
        add $s7, $s7, $s5 	# Add 12 to $s7 and store the result in $s7
        j back_to_endMetting
  	
  	
less_than_or_equal_5_forStart_OH:

        #add 12 to can subtract for start time 
        li $s5, 12       # Load the value 12 into s5
        add $s6, $s6, $s5	# Add 12 to $s6 and store the result in $s6
        j back_to_startOH


less_than_or_equal_5_forEnd_OH:
        
        #add 12 to can subtract for end time 
        li $s5, 12      # Load the value 12 into s5
        add $s7, $s7, $s5 	# Add 12 to $s7 and store the result in $s7
  	j back_to_endOH
  
  	## All back jump to back to subract	
 ###################################################################################################3
  	
view_statistics:
        li $v0, 4
        la $a0, choice_statistics
        syscall

        # Read user input for this choice
        li $v0, 5
        syscall
        move $t8, $v0  # $t8 now contains the user choice

        # Check the user choice
        beq $t8, 1, Luctures_Hours
        beq $t8, 2, OHs_Hours
        beq $t8, 3, Meetings_Hours 
        beq $t8, 4, avg_L 
        beq $t8, 5, radio_between_L_OH
        beq $t8, 0, menu
        #if not from above try again
        li $v0, 4
        la $a0,try_again
        syscall
        j view_statistics
        
        
 ##############################################################################33 	
Luctures_Hours:

        li $v0, 4
        la $a0, choice_L
        syscall

        li $v0, 1      # syscall code for print_int
        move $a0, $s2   # load the value from $s2 into $a0 ## $s2 is Hours of luctures
        syscall
  
        j  view_statistics 
        
 #######################################################################
OHs_Hours:

        li $v0, 4
        la $a0, choice_OH
        syscall
        
        li $v0, 1      # syscall code for print_int
        move $a0, $s4   # load the value from $s4 into $a0 ## $s4 is Hours of OH
        syscall
        
        j  view_statistics 
 ################################################################
Meetings_Hours:
        li $v0, 4
        la $a0, choice_M
        syscall	

        li $v0, 1      # syscall code for print_int
        move $a0, $s3   # load the value from $s3 into $a0 ## $s3 is Hours of Metting
        syscall
        
        j  view_statistics 
 ################################################################
avg_L:

        li $v0, 4
        la $a0, choice_avg_L
        syscall

        lb $t9, 0($sp)      # get the value which stored in stack to here
        mtc1 $t9, $f3      # Move from integer to floating-point
        mtc1 $s2, $f4      # Move from integer to floating-point

        div.s $f5, $f4 , $f3    # Divide the hours of lucture on many days 
        li $v0, 2          # syscall code for print_float
        mov.s $f12, $f5    # load the float value into $f12
        syscall  #$f12 is the avg_lucture

        j view_statistics
        
#############################################################

radio_between_L_OH:

        li $v0, 4
        la $a0, choice_radio
        syscall

        mtc1 $s2, $f6      # Move from integer to floating-point (lucture)
        mtc1 $s4, $f7      # Move from integer to floating-point(OH)
        div.s $f8, $f6 , $f7    # Divide $f7 by $f6

        li $v0, 2          # syscall code for print_float
        mov.s $f12, $f8    # load the float value into $f12 and print it 
        syscall
        
        j view_statistics
        
##################################################################
#want add slot to the calander
add_appointment:

        #ask user to enter the day
	li $v0, 4
	la $a0,add_day 
	syscall

	# Read user input for day number
	li $v0, 5
	syscall
	move $t0, $v0  # $t0 now contains the user entered day

	# Check if the day is greater than 31
	li $t1, 31
	bgt $t0, $t1, invalid_day_message

EnterStart:
	#ask user to enter the start time
	li $v0, 4
	la $a0, add_start
	syscall

	# Read user input for start slot
	li $v0, 5
	syscall
	move $t1, $v0  # $t1 now contains the user entered start time

	# Prompt user for AM (0) or PM (1)
	li $v0, 4
	la $a0, am_pm_prompt
	syscall

	# Read user input for AM or PM
	li $v0, 5	
	syscall
	move $t4, $v0  # $t4 now contains the user-entered AM or PM

	# Adjust start time based on AM or PM
	beq $t4, 0, am_selected
	beq $t4, 1, pm_selected
	j EnterStart
EnterEndType:

	# ask user to enter end day
	li $v0, 4
	la $a0, add_end
	syscall

	# Read user input for end day 
	li $v0, 5
	syscall
	move $t2, $v0  # $t2 now contains the user entered appointment type

	# Prompt user for AM (0) or PM (1)
	li $v0, 4
	la $a0, am_pm_prompt
	syscall

	# Read user input for AM or PM
	li $v0, 5
	syscall
	move $t4, $v0  # $t4 now contains the user-entered AM or PM

	# Adjust start time based on AM or PM
	beq $t4, 0, am_selected1
	beq $t4, 1, pm_selected1
	j EnterEndType
EnterType:

	beq $t1,$t2, start_end_equal #check if the start and end time is equal

	# ask user to enter appointment type
	li $v0, 4
	la $a0, add_type
	syscall

	# Read user input for appointment type
	li $v0, 12
	syscall
	move $t3, $v0  # $t3 now contains the user entered appointment type

	la $a1, pointer_entries   # array address where we stored the file in memory
	li $t5, 0         # index variable

check_found:

        lb $t7, 0($a1)  # Load the day at the current index in memory

        # Compare the day with what the user entered day
        beq $t7, $t0, is_found #check if the day is found
	bnez $t7, not_end_of_pointer_entries2 # check if end of entries
	li $v0, 4        # syscall code for print_str
	la $a0, newline
	syscall
    
	li $v0, 4
	la $a0, not_found_create
	syscall
   
	### if this a new day incremant the number of days which stored in stack
	lb $t9, 0($sp)      # Load the value  from the stack to $t9 
	addi $t9,$t9,1
	sb $t9, 0($sp)      # Save the value of $t9 to the stack
	j end_add_appointment


is_found:

	li $s5, 5        # Load the value 5 into $s5
	move $s6,$t1 # value of entered start time 
	move $s7,$t2 # value of entered end time 

	# Load start time and end time for comparison
	lb $t8, 4($a1)   # Load start time
	lb $t9, 8($a1)   # Load end time
    
	#ckeck is the slot the user entered if conflict or not    
	beqz $t8,end_add_appointment 
	ble $t8,$s5, lless_5  # branch if $t8 less than 5

back_here1:

	li $s5, 5        # Load the value 5 into $s5
	ble $t9,$s5, lless_than_5   # branch if $t9 less than 5

back_here2: 
     
        li $s5, 5        # Load the value 5 into $s5
	ble $t1,$s5, less_5   # branch if $t1 less than 5
	
back_here3:

	li $s5, 5        # Load the value 5 into $s5
	ble $t2,$s5, less_than_5    # branch if $t2 less than 5

back_here4:
   
	# Check for time conflicts
	bge $s6, $t8, check_if_start_between
	blt $s6, $t8, check_if_end_between

cintin:

	# No time conflict go to check  next slot 
	addi $t5, $t5, 16  # increment index to check the far from begining from start entries
	addi $a1, $a1, 16     # increment index to arrive next slot
	j is_found # check again if the time is free

time_conflict_found:

	#print statment about the conflict
	li $v0, 4
	la $a0,conflict
	syscall
	j menu
    
    
not_end_of_pointer_entries2:
    
	#go to next day that stored
	add $a1, $a1, 160 
	j  check_found # to check if the day is found

end_add_appointment:
	
	# Store the new slot that add 
	sb $t0, 0($a1)  # Store day index
	sb $t1, 4($a1)  # Store start time
	sb $t2, 8($a1)  # Store end time
	sb $t3, 12($a1) # Store appointment type
	beq $t3,'O',print_H
	beq $t3,'o',print_H
   
clear_it:
  
	li $s5, 5  # Load the  value 12 into $t5
	ble $t1,$s5, lessthan_5    #branch if less than 5
    
back_afteradd12:  

	li $s5, 5  # Load the  value 12 into $t5
	ble $t2,$s5, lessthann_5    #branch if less than 5
      
backk_afteradd12:
    
	sub $s6,$t2,$t1 #calclate the number of hours for this Type
	beq $t3,'L',change_on_luctures
	beq $t3,'l',change_on_luctures
	beq $t3,'O',change_on_OH
        beq $t3,'o',change_on_OH
        beq $t3,'M',change_on_M
        beq $t3,'m',change_on_M

more:

	addi $a1, $a1, 16  #move to next slot
	j write_in_file     
    

print_H:
	li $t8, 0x48
	 sb $t8, 11($a1) # Store appointment type
        j clear_it 
        
        
lessthan_5:

	li $s5, 12       # Load the  value 12 into $t5
	add $t1, $t1, $s5 # Add 12 to $t1 and store the result in $t1
	j back_afteradd12

lessthann_5:
  
	li $s5, 12       # Load the  value 12 into $t5
	add $t2, $t2, $s5 # Add 12 to $t2 and store the result in $t2
	j backk_afteradd12

change_on_luctures:

	add $s2,$s2,$s6
	j more

change_on_OH:

	add $s4,$s4,$s6
	j more
	
change_on_M:

	add $s3,$s3,$s6
	j more
	
check_if_start_between:

	blt $s6, $t9, time_conflict_found
	j cintin
	
check_if_end_between:

	bgt $s7, $t8, time_conflict_found
	j cintin  
  
lless_5:

	li $s5, 12       # Load the  value 12 into $t5
	add $t8, $t8, $s5 # Add 12 to $t8 and store the result in $t8
	j back_here1
	
lless_than_5:
	
	li $s5, 12       # Load the  value 12 into $t5
	add $t9, $t9, $s5 # Add 12 to $t9 and store the result in $t9
	j back_here2
  
less_5:
 
  	 li $s5, 12       # Load the  value 12 into $t5
	add $s6, $s6, $s5 # Add 12 to $s6 and store the result in $s6
	j back_here3
	
less_than_5:

        li $s5, 12       # Load the  value 12 into $t5
	add $s7, $s7, $s5 # Add 12 to $s7 and store the result in $s7
	j back_here4

start_end_equal:

	li $v0, 4
	la $a0,end_start_equal # start and end time is equal 
	syscall
	j add_appointment #ask user to repeat add oppointment

am_selected:

	li $t8, 8
	blt $t1, $t8, print_lecture_start_time
	li $t4,12
	beq $t1, $t4,print_end_time_message
	j EnterEndType 


pm_selected:
	
	li $s5, 12
	beq $t1, $s5, number_is_12_message_Start_Time
	add $t1, $t1, $s5
	li $t3, 17
	bgt $t1, $t3, print_end_time_message
	j EnterEndType #ENTER end time from the user
	
number_is_12_message_Start_Time:

	j EnterEndType
	

print_lecture_start_time:

	# Print a message indicating that the lecture starts at 8 am
	li $v0, 4
	la $a0, lecture_start_time_message
	syscall
	j add_appointment

am_selected1:

	li $t3, 8
	blt $t2, $t3, print_lecture_start_time
	li $t4,12
	beq $t2, $t4,print_end_time_message
	j CompareEndTimeStartTime #ENTER end time from the user

pm_selected1:

	li $s5, 12
	beq $t2, $s5, number_is_12_message
	add $t2, $t2, $s5
	li $t3, 17
	bgt $t2, $t3, print_end_time_message
	j CompareEndTimeStartTime

number_is_12_message:

	j CompareEndTimeStartTime
	
	
CompareEndTimeStartTime:

	blt $t2, $t1, invalid_time_range_message
	li $t7,12
	bgt $t1, $t7, GreaterThan12
	bgt $t2, $t7, GreaterThan121
	j EnterType

GreaterThan12:
	
	li $t7,12
	sub $t1,$t1,12
	bgt $t2, $t7, GreaterThan121
	j EnterType
	
GreaterThan121:

	li $t7,12
	sub $t2,$t2,12
	j EnterType
		
invalid_time_range_message:

	# Print a message indicating that the lecture starts time is greater than the end time
	li $v0, 4
	la $a0, lecture_conflict
	syscall
	j add_appointment

print_end_time_message:

	# Print a message indicating that appointments cannot be added after 5 PM
	li $v0, 4
	la $a0, end_time_limit_message
	syscall
	j add_appointment

invalid_day_message:

	li $v0, 4
	la $a0, invalid_day_error_message
	syscall
	j add_appointment

###############################################################################
#delete oppointment
delete_appointment:

	# ask user to enter day number
	li $v0, 4
	la $a0,add_day 
	syscall

	# Read user input for day number
	li $v0, 5
	syscall
	move $t0, $v0  # $t0 now contains the user entered day

	# ask user to enter start time 
	li $v0, 4
	la $a0, add_start
	syscall

	# Read user input for time start for slot
	li $v0, 5
	syscall
	move $t1, $v0  # $t1 now contains the user entered start time

	# ask user to enter end time  
	li $v0, 4
	la $a0, add_end
	syscall

	# Read user input for end time for slot
	li $v0, 5
	syscall
	move $t2, $v0  # $t2 now contains the user entered end time
	beq $t1,$t2, start_end_equal_for_delete #check if start and end are equal

	# ask user to enter the Type of the appointment 
	li $v0, 4
	la $a0, add_type
	syscall

	# Read user input for appointment type
	li $v0, 12
	syscall
	move $t3, $v0  # $t3 now contains the user entered appointment type
	la $a1, pointer_entries   # array address
	li $t5, 0         # index variable

check_found_for_delete:

	lb $t7, 0($a1)  # Load the day from the array  in memory
	#check if found the day 
	beq $t7, $t0, is_foundfor_delete
	bnez $t7, not_end_of_pointer_entries_for_Delete #check if end of array
    
	li $v0, 4        # syscall code for print_str
	la $a0, newline
	syscall
    
	li $v0, 4
	la $a0, not_found_for_delete
	syscall
	j menu
    
not_end_of_pointer_entries_for_Delete:

	#move to next day in array entries
	add $a1, $a1, 160  
	j  check_found_for_delete #jump to check if the day is found 
    
is_foundfor_delete: #if the day is found for delete
    
	# Load start time and end time for comparison
 	li $v0, 4        # syscall code for print_str
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0,found
	syscall
	
checks:  
  
	lb $t8, 12($a1)   # Load the type
	beq $t8,$t3, start_check # check if the type are the same what we want to delete
	bne $t8,$t3, continue_search  #the type is not what we look for 
    
end_delete_appointment:  

	li $v0, 4        # syscall code for print_str
	la $a0, nofound
	syscall
	j menu
   
start_check:

	lb $t7, 4($a1)   # Load end time
	lb $t9, 8($a1)   # Load end time
	li $s5, 5        # Load the value 5 into $s5
  	ble $t1,$s5, less_than_or_equal_5_forDelete1   # Branch if less than 5

back_to_check1:
 	       
	li $s5, 5        # Load the value 5 into $s5
 	ble $t2,$s5, less_than_or_equal_5_forDelete2    # Branch if less than 5
 	
back_to_check2:

	li $s5, 5        # Load the value 5 into $s5
 	ble $t7,$s5, less_than_or_equal_5_forDelete3   # Branch if less than 5
 	
back_to_check3:

 	 li $s5, 5        # Load the value 5 into $s5
 	ble $t9,$s5, less_than_or_equal_5_forDelete4    # Branch if less than 5
 	
back_to_check4:
  
	# check the slot want to remove if exist in this day 
	beq $t1, $t7, check_if_equal_delete 
	bgt $t1, $t7, check_if_start_between_delete
	blt $t1, $t7, check_if_end_between_delete
  
continue_search:

	beqz $t8,end_delete_appointment  #if equal zero so the slot is not found
	addi $a1, $a1, 16 #go to next slot
	j  checks
   
check_if_equal_delete:

 	b delete_it 
 	
check_if_start_between_delete:

	blt $t1, $t9, delete_it
	j continue_search
	
check_if_end_between_delete:

        bgt $t2, $t7, delete_it
	j continue_search
 
delete_it:

	sub $s6,$t9,$t7
	beq $t3,'L',change_on_luctures_afterDelete
	beq $t3,'l',change_on_luctures_afterDelete
	beq $t3,'O',change_on_OH_afterDelete
	beq $t3,'o',change_on_OH_afterDelete
	beq $t3,'M',change_on_M_afterDelete
	beq $t3,'m',change_on_M_afterDelete
	
start_checking_delete:

	li $t0, 0   # start time
	li $t1, 0   # start time
	li $t2, 0   # end time
	li $t3, 0   # appointment type
	sb $t0, 0($a1)  # Store day index
	sb $t1, 4($a1)  # Store start time
	sb $t2, 8($a1)  # Store end time
	sb $t3, 12($a1) # Store appointment type
	sb $t3, 11($a1) # Store appointment type           
	add $t7, $a1, 16      #t7 pointer to the next slot of $a1
	li $t9,0
	
	
#make shift for all next slots after delete slot           
Shifting_slot_loop:
	
	lb $t8, 0($t7)  # Load the value of the next element
	sb $t8, 0($a1)  # Store the value at the current position
  
	lb $t8, 4($t7)  # Load the value of the next element
	sb $t8, 4($a1)  # Store the value at the current position
  
	lb $t8, 8($t7)  # Load the value of the next element
	sb $t8, 8($a1)  # Store the value at the current position
  
	lb $t8, 11($t7)  # Load the value of the next element
	sb $t8, 11($a1)  # Store the value at the current position  
  
	lb $t8, 12($t7)  # Load the value of the next element
	sb $t8, 12($a1)  # Store the value at the current position
  
	addi $a1, $a1, 16  # Move to the next position
	addi $t7, $t7, 16  # Move to the next position
	addi $t9, $t9, 16  # Move to the next position
	bnez $t8, Shifting_slot_loop
	sub $a1, $a1,$t9  # back to the start pointer of the same day we are in their slot    
	lb $t8, 0($a1)  # Load the value of the day
	beqz $t8,goo #check if the day is removed all
	j  reset_wf

goo:

	li $v0, 4
	la $a0, remove_all_day
	syscall

	#decrement the numbers of days after delete day
	lb $t9, 0($sp)      # Load the value of the stack to $t9
	subi $t9,$t9,1
	sb $t9, 0($sp)      # Save the value of $t9 to the stack
	add $t7, $a1,160  # go to next day 
	li $t9,0
	
#shift the all day to new address after delete day         
 Shifting_slot_loop1:
 
 	lb $t8, 0($t7)  # Load the value of the next element
	sb $t8, 0($a1)  # Store the value at the current position
  
	lb $t8, 4($t7)  # Load the value of the next element
	sb $t8, 4($a1)  # Store the value at the current position
  
	lb $t8, 8($t7)  # Load the value of the next element
	sb $t8, 8($a1)  # Store the value at the current position
  
	lb $t8, 11($t7)  # Load the value of the next element
	sb $t8, 11($a1)  # Store the value at the current position  
  
	lb $t8, 12($t7)  # Load the value of the next element
	sb $t8, 12($a1)  # Store the value at the current position
  
	addi $a1, $a1, 16  # Move to the next position
	addi $t7, $t7, 16  # Move to the next position
	addi $t9, $t9, 16  # Move to the next position

	bnez $t8,Shifting_slot_loop1 # continue shift the slot of the days
	beqz  $t8,to_next # start to shift all day
	j  reset_wf
    
    
to_next:

	sub $a1, $a1,$t9  # Calculate the address of the next element       
	addi $a1, $a1,160  # Calculate the address of the next element       
	addi $t7, $a1,160  # Calculate the address of the next element 
	lb $t8, 0($t7)  # Load the value of the array
	beqz  $t8,reset  #reset the last day information stored because it was shifted
	li $t9,0
	j Shifting_slot_loop1  

reset:

	li $t0, 0   # start time
	li $t1, 0   # start time
	li $t2, 0   # end time
	li $t3, 0   # appointment type
	addi $t7, $a1,16  # Calculate the address of the next element 
       lb $t8, 0($t7)  # Load the value of the element
       
	sb $t0, 0($a1)  # Store day index
	sb $t1, 4($a1)  # Store start time
	sb $t2, 8($a1)  # Store end time
	sb $t3, 12($a1) # Store appointment type
	sb $t3, 11($a1) # Store appointment type       
	addi $a1, $a1,16  # Calculate the address of the next element     
	bnez $t8,reset
	j reset_wf

less_than_or_equal_5_forDelete1 :

	#add 12 to the time
	li $s5, 12       # Load the  value 12 into $t5
	add $t1, $t1, $s5 # Add 12 to $t1 and store the result in $t1
	j back_to_check1

   
less_than_or_equal_5_forDelete2 :
#add 12 to the time
li $s5, 12       # Load the  value 12 into $t5
add $t2, $t2, $s5 # Add 12 to $t2 and store the result in $t2
j back_to_check2

   
      
 less_than_or_equal_5_forDelete3 :
#add 12 to the time
li $s5, 12       # Load the  value 12 into $t5
add $t7, $t7, $s5 # Add 12 to $t7 and store the result in $7
j back_to_check3

   
         less_than_or_equal_5_forDelete4 :
#add 12 to the time
li $s5, 12       # Load the  value 12 into $t5
add $t9, $t9, $s5 # Add 12 to $t9 and store the result in $t9
j back_to_check4   


## changing the numbeer of Hours for lucture,OH,metting after Delete a slot 
change_on_luctures_afterDelete:
sub $s2,$s2,$s6
j   start_checking_delete
change_on_OH_afterDelete:
sub $s4,$s4,$s6
j   start_checking_delete
change_on_M_afterDelete:
sub $s3,$s3,$s6
j   start_checking_delete



start_end_equal_for_delete:
 li $v0, 4
    la $a0,end_start_equal
    syscall
j delete_appointment

#________________________________________________________________________________________________
view_time_slot:

	la $a1, pointer_entries   # array address
	
	# Ask user to enter the day index
	li $v0, 4
	la $a0, enter_day
	syscall

	# Read user input for day index
	li $v0, 5
	syscall
	move $t0, $v0  # $t0 now contains the user's input for day index

	# Ask user to enter the start time
	li $v0, 4
	la $a0, enter_start_time
	syscall

	# Read user input for start time
	li $v0, 5
	syscall
	move $s0, $v0  # $t6 now contains the user's input for start time

	# Ask user to enter the end time
	li $v0, 4
	la $a0, enter_end_time
	syscall

	# Read user input for end time
	li $v0, 5
	syscall
	move $s1, $v0  # $t7 now contains the user's input for end time

	# Add checks for s0
	li $s5, 5  
	ble $s0, $s5, LessThanOREqual5_s0
	ble $s1, $s5, LessThanOREqual5Slot_S1
	j InitializeVariables #go to varoable

LessThanOREqual5_s0:

	#check is equal oe less than 5
	li $s5, 12
	add $s0, $s0, $s5
	j Compare_s1

Compare_s1:
   
	li $s5, 5  
	ble $s1, $s5, LessThanOREqual5Slot_S1
	j InitializeVariables

LessThanOREqual5Slot_S1:

	li $s5, 12
	add $s1, $s1, $s5
    
InitializeVariables:
    
	li $t8, 0  # Loop counter for appointments
	li $t9, 0  # Flag to indicate if the day is found
	li $t5, 0

search_day_slot:

	li $s5, 0

	# Load the day index at the current position in memory
	lb $t4, 0($a1)
	beqz, $t4, not_found1

 	# Check if the current entry is for the specified day
	beq $t4, $t0, day_found1

	# Move to the next entry in memory
	addi $a1, $a1, 160  # Each entry has four elements of size 4 bytes, adjust based on your data structure
  
	# Increment the iteration counter
	addi $t5, $t5, 1
	j search_day_slot

day_found1:
    
	li $v0, 4
	la $a0, found
	syscall
	j get_slot
     
get_slot :

	# Load the slot information
	lb $t6, 4($a1)  # Load start time
	move $s6, $t6
	beqz $t6, end_ofDay
	lb $t7, 8($a1)  # Load end time
	move $s7, $t7
    
	# Add checks for s6 and s7
	li $s5, 5  
	ble $s6, $s5, LessThanOREqual5Slot_S3
	ble $s7, $s5, LessThanOREqual5Slot_S4
	j compare

LessThanOREqual5Slot_S3:

	li $s5, 12
	add $s6, $s6, $s5
	j Compare_s7

Compare_s7:
  
	ble $s7, $s5, LessThanOREqual5Slot_S4
	j compare

LessThanOREqual5Slot_S4:

	li $s5, 12
	add $s7, $s7, $s5
	j compare

compare:
	# if user's start (s0) is greater than the end time of the current slot (s7), move to next slot
	# if user's end (s1) is smaller than the start time of the current slot (s6), move to next slot
	bgt $s0, $s7, check_next_slot
	blt $s1, $s6, check_next_slot
	
	ble $s6, $s0, print_s0
	j print_s6
	
continue_compare:
	
	ble $s7, $s1, print_s7
	j print_s1
	
check_next_slot:

	addi $a1, $a1, 16
	j get_slot
	
print_s0:
	# Print the slot information
    	li $v0, 4
    	la $a0, slotInfo
    	syscall
    	
	move $a0, $s0	# start time from user
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, dash
	syscall
	j continue_compare

print_s1:

	move $a0, $s1	# end time from user
	li $v0, 1
	syscall
	j print_type
	
print_s6:

	# Print the slot information
   	li $v0, 4
    	la $a0, slotInfo
    	syscall
    	
	move $a0, $s6	# start time from calendar
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, dash
	syscall
	
	j continue_compare
	
print_s7:

	move $a0, $s7	# end time from calendar
	li $v0, 1
	syscall
	j print_type
	
print_type:

	#This is to print L, M, or OH after slot
	li $v0, 4       
	la $a0, spacee    
	syscall
	

	lb $t7, 12($a1)
	move $a0, $t7 
	li $v0, 11
	syscall
	
	beq $t7,'O',pr_H
	beq $t7,'O',pr_H

after_pr_H:
	
	#print new line
    	li $v0, 4       
	la $a0, newline       
	syscall
	
	li $s5, 1  # flag means day has an activity (not free
	j check_next_slot 
	
pr_H:

	lb $t7, 11($a1)
	move $a0, $t7 
	li $v0, 11
	syscall
	j after_pr_H	
		
end_ofDay:

	beq $s5, 0, day_isFree  #if the flag remain zero then the day is free at the time slot user entered
	beq $s5, 1, exit 

day_isFree:
	
	li $v0, 4
	la $a0, dayFree
	syscall
	j exit

not_found1:

	li $v0, 4
	la $a0, day_not
	syscall
	j menu
    
exit:
	li $v0, 10
	j menu
    	syscall
    	
    	
###########################################################################################################################    	
write_in_file:    
    
    ##########################write file
    # Open the file for writing
      #open file 
      
      li $v0,13           	# open_file syscall code = 13
    	la $a0,output_filename     	# get the file name
   	li $a1,1           	# file flag = write (1)
    	syscall
    	move $s1,$v0    

      
      la $t7, pointer_entries   # array address
       la $t5, buffer2     # load the address of buffer2 to $t5
       
 writer: 
 ### open the file
          li $t6,0   	# open_file syscall code = 13
          li $t3,4   	# open_file syscall code = 13	      
          lb $t9,0($t7)    # load the address of the entries
          move $t8, $t9      #  convert integer  to ASCII
          li $t2, 10           # Set divisor to 10 for div by it to get the days


      move $t4, $t8     
##start convert      
convert_loop:
  div $t8, $t2         # Divide the integer by 10
  mflo $t1             # Move quotient back to $t1
  mfhi $t8             # Move remainder to $t8
  beqz $t1, convert_zero #check if the quotient is zero 
  addi $t1, $t1, '0'   # Convert quotient to ASCII 
  
  sb $t1, 0($t5)     # Store the value in $t1 in the buffer2

 add $t5,$t5,1 #move to next elemnet in buffer2
   	
   	
    	mul $t8,$t8,10 # multiply the remainder by 10
    	 #check if the day was 10 or 20 or 30 to handle 0
        beq $t4,10,checkzero 
        beq $t4,20,checkzero
        beq $t4,30,checkzero
        doneCheck:
    bnez $t8, convert_loop # Repeat until remainder is zero 
    
    lb $t1, colon # store the colon 
  sb $t1, 0($t5)     # Store the value in $t1 in the buffer2   	 
   add $t5,$t5,1
    lb $t1, spacee
 sb $t1, 0($t5)     # Store the value in $t1 in the buffer2   	
    add $t7,$t7,4
    add $t5,$t5,1
j for_start

#################################################################
#loop here to store more than one slot to same day
for_start:

   lb $t9,0($t7)    # load the address of the array
       move $t8, $t9      #  convert integer to ASCII
         li $t2, 10           # Set divisor to 10 for div by it to get the start time


   
  
        move $t4, $t8     
convert_loop1:
  div $t8, $t2         # Divide the integer by 10
  mflo $t1             # Move quotient back to $t1
  mfhi $t8             # Move remainder to $t8
  beqz $t1, convert_zero1 #check if the quotient is zero 
  addi $t1, $t1, '0'   # Convert quotient to ASCII
  
  sb $t1, 0($t5)     #Store the value in $t1 in the buffer2	 

 add $t5,$t5,1 	 #move to next element in buffer2
   	

    mul $t8,$t8,10  # multiply the remainder by 10
    	   #check if the day was 10 or 20 or 30 to handle 0
        beq $t4,10,checkzero1
        beq $t4,20,checkzero1
        beq $t4,30,checkzero1
        doneCheck1:
    bnez $t8, convert_loop1 # Repeat until remainder is zero 
 
    lb $t1, dash
  sb $t1, 0($t5)     # Store the value in $t1 in the buffer2 
 add $t7,$t7,4 # 4 becuse the buffer is stored 4 by 4
    add $t5,$t5,1  # 1 becuse the buffer is stored 1 by 1
j for_end 
#################################################################
#loop here to store more than one slot to same day
for_end:

   lb $t9,0($t7)    # load the address of the array
       move $t8, $t9      #  converte integer to ASCII
         li $t2, 10           # Set divisor to 10 for div by it to get the end time

   

        move $t4, $t8     
convert_loop2:
  div $t8, $t2         # Divide the integer by 10
  mflo $t1             # Move quotient back to $t1
  mfhi $t8             # Move remainder to $t8
  beqz $t1, convert_zero2 	 #check if the quotient is zero 
  addi $t1, $t1, '0'   # Convert quotient to ASCII

  
  sb $t1, 0($t5)    #Store the value in $t1 in the buffer2	 

 add $t5,$t5,1 	 #move to next element in buffer2
   	

    mul $t8,$t8,10  # multiply the remainder by 10
    	   #check if the day was 10 or 20 or 30 to handle 0
        beq $t4,10,checkzero2
        beq $t4,20,checkzero2
        beq $t4,30,checkzero2
        doneCheck2:
    bnez $t8, convert_loop2 # Repeat until remainder is zero 
 
    lb $t1, spacee
  sb $t1, 0($t5)     # Store the value in $t1 in the buffer    	
 add $t7,$t7,4
    add $t5,$t5,1
   
j typee_t
#################################################################
#loop here to store more than one slot to same day

typee_t:

   lb $t9,0($t7)    # load the address of the array
       move $t8, $t9      

  sb $t8, 0($t5)     # Store the value in $t8 in the buffer2
 add $t5,$t5,1
    add $t3,$t3,16 #to sub it to back to first element in same day 

 beq $t8 ,'O',printHh
  beq $t8 ,'o',printHh
  con:
  add $t7,$t7,8  #check if there a data in same day
     lb $t9,0($t7)    # load the address of the array
     
       beq $t9, 0,checking_more_data #check if there a data to print new line or comma

    lb $t1, commaa
  sb $t1, 0($t5)     # Store the value in $t1 in the buffer2
    add $t5,$t5,1
  lb $t1, spacee
  sb $t1, 0($t5)     # Store the value in $t1 in the buffer2
    add $t5,$t5,1

j for_start # to store the other slot in same day

printHh:
  li $t1, 0x48
  sb $t1, 0($t5)     # Store the value in $t0 in the buffer2   
     add $t5,$t5,1
    j con


checking_more_data:

  sub $t7,$t7,$t3 #back to start element in the day
  add $t7,$t7,160 #go to next day
  lb $t9,0($t7)    # load the address of the array
 
       beq $t9, 0,last #check if there another day after that
       
     lb $t1, newline #print new line in the buffer2
  sb $t1, 0($t5)     # Store the value in $t0 in the buffer
    add $t5,$t5,1 
   
j writer #loop to store all lines

#if arrive the end day in the calendar
last:
 #print the buffer2 inside the file
 li $v0, 15             # write_file syscall code = 15
  move $a0, $s1          # file descriptor
  la $a1, buffer2         # the buffer that will be written
  la $a2, 2048    # length of the buffer
 syscall
 
#close the file
li $v0, 16       # syscall code for close
syscall

j menu




checkzero:
          li $t0,0   	
 	  addi $t1, $t0, '0'   # Convert 0 to ASCII
  	  sb $t1, 0($t5)     # Store the value in $t1 in the buffer2    	
 	add $t5,$t5,1
	j doneCheck

checkzero1:
	     li $t0,0   	
 	addi $t1, $t0, '0'   # Convert 0 to ASCII
 	 sb $t1, 0($t5)     # Store the value in $t1 in the buffer 
 	add $t5,$t5,1
	j doneCheck1
     
 checkzero2:
          li $t0,0   	
 	addi $t1, $t0, '0'   # Convert 0 to ASCII
 	 sb $t1, 0($t5)     # Store the value in $t1 in the buffer  
 	add $t5,$t5,1
	j doneCheck2
             
    
  convert_zero:
      mul $t8,$t8,10
j doneCheck
      
  convert_zero1:
      mul $t8,$t8,10
j doneCheck1
    
    
      
  convert_zero2:
      mul $t8,$t8,10
j doneCheck2
    
       	
    	
   #######reset the buffer to store in it again if delete a slot  	
 reset_wf:
         la $a0, buffer2     # Store the value of  the buffer into $a0 
         li $a1,2048
         li $t0,0
  Loop:
  
        sb   $t0, 0($a0) # Store zero  at the current address
        addi $a0, $a0, 1  # Move to the next byte in the buffer
        subi $a1, $a1, 1  # Decrement the size counter
        bnez $a1, Loop    # Branch to Loop if the size is not zero    	
    	
    	j write_in_file
 ############################################################################   	
    	
 exitt:
  # Exit system call
    li $v0, 10       # Load the syscall number for exit into $v0
    syscall          # Make the system call
   	
    	
    	
