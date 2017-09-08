#hacer como esto: bind . destroy exit_command
package require Tk

set filename "Untitled"
set fue_guardado 0
set texto_a_verificar ""

#Procedimientos del menu
proc new_command {} {
    global filename
    global texto_a_verificar
	set text_area_text [.t get 1.0 end]
	if {$text_area_text ne $texto_a_verificar} {
        set answer [tk_messageBox -message "Do you want to save changes to $filename?" \
                                  -icon question \
                                  -type yesnocancel \
                                  -title editor]
        switch $answer {
			yes {
				save_as_command
				#Despues poner lo siguiente en una funcion porque se hace 3 veces.
				.t delete 1.0 end
				set texto_a_verificar [.t get 1.0 end]
				set filename "Untitled"
                wm title . "Editor - $filename"
			}
			no {
				.t delete 1.0 end
				set texto_a_verificar [.t get 1.0 end]
				set filename "Untitled"
                wm title . "Editor - $filename"
			}
		}
	} else {
		.t delete 1.0 end
		set texto_a_verificar [.t get 1.0 end]
		set filename "Untitled"
		wm title . "Editor - $filename"
    }
}

proc open_command {} {
    global texto_a_verificar
    global fue_guardado
    global filename
	set text_area_text [.t get 1.0 end]
	if {$text_area_text ne $texto_a_verificar} {
		global filename
        set answer [tk_messageBox -message "Do you want to save changes to $filename?" \
								  -icon question \
								  -type yesnocancel \
								  -title editor]
		switch $answer {
			yes {
				save_as_command
				set types {
					{{Text Files} {.txt}}
                    {{All Files}   *       }
                }
                set filename [tk_getOpenFile -filetypes $types -defaultextension .txt]
                try {
					set file [open $filename r]
                    set the_text [read $file]
                    .t replace 1.0 end $the_text
				    set texto_a_verificar [.t get 1.0 end]
					set fue_guardado 1
					wm title . "Editor - $filename"
				} trap {POSIX ENOENT} {} {
					#do nothing
                }
			}
			no{
				set types {
					{{Text Files} {.txt}}
                    {{All Files}   *       }
                }
                set filename [tk_getOpenFile -filetypes $types -defaultextension .txt]
                try {
					set file [open $filename r]
                    set the_text [read $file]
                    .t replace 1.0 end $the_text
                    wm title . "Editor - $filename"
				    set texto_a_verificar [.t get 1.0 end]
					set fue_guardado 1
					wm title . "Editor - $filename"
				} trap {POSIX ENOENT} {} {
					#do nothing
                }
			}
		}											 
	} else {
		set types {
			{{Text Files} {.txt}}
            {{All Files}   *       }
        }
		set filename [tk_getOpenFile -filetypes $types -defaultextension .txt]
		try {
			set file [open $filename r]
			set the_text [read $file]
			.t replace 1.0 end $the_text
			wm title . "Editor - $filename"
			set texto_a_verificar [.t get 1.0 end]
			set fue_guardado 1
			wm title . "Editor - $filename"
		} trap {POSIX ENOENT} {} {
			#do nothing
		}
	}			
}

proc save_command {} {
	global fue_guardado
	if {$fue_guardado eq 0} {
		save_as_command
	} else {
		global filename
        set file [open $filename w]
        set text_widget_text [.t get 1.0 end]
        puts $file $text_widget_text 
        close $file
    }
}	

proc save_as_command {} {
    global filename
    global fue_guardado
	set types {
		{{Text Files} {.txt}}
        {{All Files}   *       }
    }
    global filename
    set filename [tk_getSaveFile -filetypes $types -defaultextension .txt]
    try {
		set file [open $filename w]
		set text_widget_text [.t get 1.0 end]
		puts $file $text_widget_text 
		close $file
		set fue_guardado 1
		wm title . "Editor - $filename"
	} trap {POSIX ENOENT} {} {
		#do nothing
    }
}

proc exit_command {} {
    global filename
    global texto_a_verificar
	set text_area_text [.t get 1.0 end]
	if {$text_area_text ne $texto_a_verificar} {
        puts "verdadero"
        set answer [tk_messageBox -message "Do you want to save changes to $filename?" \
                                  -icon question \
                                  -type yesnocancel \
                                  -title editor]
        switch $answer {
			yes {
				save_as_command
                exit
			}
			no {
				exit
			}
		}
	} else {
		exit
    }
}

menu .m -type menubar
. configure -menu .m
.m add cascade -label "File" -menu .m.file
menu .m.file
.m.file add command -label "New"        -command new_command
.m.file add command -label "Open..."    -command open_command
.m.file add command -label "Save"       -command save_command
.m.file add command -label "Save As..." -command save_as_command
.m.file add separator
.m.file add command -label "Exit"       -command exit_command

wm title . "Editor - $filename"

scrollbar .scrolly -orient v -command ".t yview"
scrollbar .scrollx -orient h -command ".t xview"
text .t -yscrollcommand ".scrolly set" -xscrollcommand ".scrollx set" -wrap none
pack .scrollx -side bottom -fill x
pack .scrolly -side right -fill y
pack .t -fill both -expand true

focus .t

set texto_a_verificar [.t get 1.0 end]
