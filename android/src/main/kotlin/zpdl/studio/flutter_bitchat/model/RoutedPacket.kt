package zpdl.studio.flutter_bitchat.model

import zpdl.studio.flutter_bitchat.protocol.BitchatPacket

/**
 * Represents a routed packet with additional metadata
 * Used for processing and routing packets in the mesh network
 */
data class RoutedPacket(
    val packet: BitchatPacket,
    val peerID: String? = null,           // Who sent it (parsed from packet.senderID)
    val relayAddress: String? = null      // Address it came from (for avoiding loopback)
)