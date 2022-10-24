using Pkg; Pkg.activate(".")
using Toolips
using Revise
using InsideEmsComputer

IP = "127.0.0.1"
PORT = 8000
InsideEmsComputerServer = InsideEmsComputer.start(IP, PORT)
