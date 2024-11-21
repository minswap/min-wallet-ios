func shortenAddress(_ address: String) -> String {
  if address.count <= 12 {
    return address
  }

  let first6Characters = address.prefix(6)
  let last6Characters = address.suffix(6)
  return "\(first6Characters)...\(last6Characters)"
}
