install.packages("serial")
library(serial)

# Create serial conection
arduino <- serialConnection(
  port = "com1", # set your port here
  mode = "9600,n,8,1", # 9600 baud rate
  newline = TRUE
)

# Open serial connection
open.serialConnection(arduino)
# Check serial connection state
isOpen.serialConnection(arduino)

# Read serial connection
print(read.serialConnection(arduino))

# Close connection
close.serialConnection(arduino)