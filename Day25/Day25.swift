
func loopSize(publicKey: Int) -> Int {
    var (loopSize, value) = (0, 1)
    while value != publicKey {
        value = (value * 7) % 20201227
        loopSize += 1
    }
    return loopSize
}

func encryptionKey(publicKey: Int, loopSize: Int) -> Int {
    (0..<loopSize).reduce(1) { result, _ in (result * publicKey) % 20201227 }
}

let publicKey = (card: 14788856, door: 19316454)
let cardLoopSize = loopSize(publicKey: publicKey.card)
let doorLoopSize = loopSize(publicKey: publicKey.door)
let encryptionKeyCard = encryptionKey(publicKey: publicKey.card, loopSize: doorLoopSize)
let encryptionKeyDoor = encryptionKey(publicKey: publicKey.card, loopSize: doorLoopSize)
print(encryptionKeyCard, encryptionKeyDoor, encryptionKeyCard == encryptionKeyDoor)