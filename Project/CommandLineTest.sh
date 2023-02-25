<<documentation
NAME           :SAJITH P
DATE           :25-02-2023
DESCRIPTION    :A shell script(named CommandLineTest.sh) which should allow user to register and the registered user to login. After login user can take a test on shell.
SAMPLE INPUT   :./CommandLineTest.sh
SAMPLE OUTPUT  :-----------------------------------------------------------
                         WELCOME                           
                -----------------------------------------------------------

                1.Sign Up
                2.Sign In
                3.Exit

                Enter Your Choice:

documentation

#STARTING OF THE PROGRAM

#!/bin/bash

#while loop to provide prompt for the user
while [ 0 ]
do
  
  #print welcome menu and read choice from the user  
  echo "-----------------------------------------------------------"
  echo -e "\e[1;44m                         WELCOME                           \e[1;m"
  echo -e "-----------------------------------------------------------\n"
  echo -e "1.Sign Up\n2.Sign In\n3.Exit\n"
  read -p "Enter Your Choice:" Choice
  
  #based on the choice do sign in, sign up or exit using switch case
  case $Choice in

       #for user sign up
       1)
          clear
          echo "-----------------------------------------------------------"
          echo -e "\e[1;44m                       SIGN UP                         \e[1;m"
          echo -e "-----------------------------------------------------------\n"

          #read username from the user and verify
          while [ 0 ]
          do
             read -p "Enter Username:" Username
             Userarray=(`cat Username.csv`)
             Flag=0
             for i in ${Userarray[@]}
             do
                if [ $i == $Username ]
                then
                    echo -e "\e[1;31mUsername already taken !\e[1;m"
                    Flag=1
                    break
                fi
             done
             if [ $Flag -eq 0 ]
             then

                 #if username verified, read password from the user and verify
                 while [ 0 ]
                 do
                    read -s -p "Enter Password:" Pass1
                    echo
                    read -s -p "Confirm Password:" Pass2
                    if [ $Pass1 == $Pass2 ]
                    then
                        echo $Username >> Username.csv
                        echo $Pass1 >> Password.csv
                        echo -e "\n\e[1;32mSignup Successfull !\e[1;m"
                        echo
                        break
                    else
                        echo
                        echo -e "\e[1;31mPasswords does not matching !\e[1;m"
                    fi
                 done
                 break
             fi
          done
          ;;

       #for user sign in
       2)
          #print welcome menu on a new page
          clear
          echo "-----------------------------------------------------------"
          echo -e "\e[1;44m                        SIGN IN                        \e[1;m"
          echo -e "-----------------------------------------------------------\n"

          #read username and verify
          while [ 0 ]
          do
             read -p "Enter Username:" Username
             Userarray=(`cat Username.csv`)
             Passarray=(`cat Password.csv`)
             Flag=0

             for i in `seq  0 $((${#Userarray[@]}-1))`
             do
                if [ ${Userarray[$i]} == $Username ]
                then
                    Flag=1

                    #if username is verified read password and verify
                    while [ 0 ]
                    do
                       read -s -p "Enter Password" Pass
                       if [ $Pass == ${Passarray[$i]} ]
                       then

                           #on successful login, provide prompt for choose an option
                           echo
                           echo -e "\e[1;32mLogin Successfull !\e[1;m"
                           echo
                           echo "-----------------------------------------------------------"
                           echo "                         TEST                            "
                           echo -e "-----------------------------------------------------------\n"

                           echo -e "1.Take Test\n2.exit\n"
                           read -p "Choose any option:" Opt

                           #using witch case to take test or exit based on option
                           case $Opt in

                                #display questions from the question bank with options to user to answer
                                1)
                                   LineCount=`cat Questions.txt | wc -l`
                                   sed -i '/.*/d' Useranswer.txt

                                   for i in `seq 6 6 $LineCount`
                                   do
                                       clear
                                       head -$i Questions.txt | tail -6

                                       #read answer from the user and store answers in file
                                       for j in `seq 10 -1 1`
                                       do
                                           #implementing timeout
                                           echo -n -e "\r Enter your answer:$j \c"
                                           read -t1 Ans

                                           if [ ${#Ans} -gt 0 ]
                                           then
                                               echo $Ans >> Useranswer.txt
                                               break
                                           fi
                                       done
                                           if [ ${#Ans} -eq 0 ]
                                           then
                                               Ans=e
                                               echo $Ans >> Useranswer.txt
                                           fi

                                   done

                                   #checking the if the answers and calcuating score
                                   Useransarray=(`cat Useranswer.txt`)
                                   Actansarray=(`cat Actualanswer.txt`)
                                   Score=0
                                   j=0
                                   clear
                                   for i in `seq 6 6 $LineCount`
                                   do
                                      echo
                                      head -$i Questions.txt | tail -6
                                      echo
                                      if [ ${Useransarray[$j]} == ${Actansarray[$j]} ]
                                      then
                                          echo -e " \e[1;32mCORRECT\e[1;m"
                                          Score=$(($Score+1))
                                      elif [ ${Useransarray[$j]} == "e" ]
                                      then
                                          echo -e " \e[1;31mTIMEOUT\e[1;m"
                                          echo " The correct answer is ${Actansarray[$j]}"
                                      else
                                          echo -e " \e[1;31mWRONG\e[1;m"
                                          echo " The correct answer is ${Actansarray[$j]}"
                                      fi
                                      j=$j+1
                                  done
                                  echo

                                  #display score
                                  echo " TOTAL MARKS OBTAINED: $Score/10"
                                  echo
                                   ;;

                                #on selecting exit option
                                2):
                                   exit
                                   ;;

                                #default cases
                                *)
                                   echo -e "\e[1;31mInvalid Option\e[1;m"
                                   ;;

                           esac



                           break
                       
                       #if password is incorrect and not verified print error message and go out of the loop
                       else
                           echo -e "\n\e[1;31mIncorrect Password\e[1;m"
                       fi
                    done
                    break
                fi
             done

             #if username doen't matched and not verified print error message and go out of the loop
             if [ $Flag -eq 0 ]
             then
                 echo -e "\e[1;31mInvalid Username\e[1;m"
             else
                 break
             fi
          done
          ;;

       #on selecting an option to exit
       3)
          exit
          ;;

       #default cases
       *)
          echo -e "\e[1;31mInvalid Choice\e[1;m"
          ;;

  esac
done

#END OF PROGRAM
