/**
 * Hive Mind Consensus Protocol
 * Implements Byzantine Fault Tolerant consensus for distributed decision-making
 */

class ConsensusProtocol {
  constructor(swarmId, agents) {
    this.swarmId = swarmId;
    this.agents = agents;
    this.quorumThreshold = Math.floor((agents.length * 2) / 3) + 1;
    this.votingRounds = new Map();
  }

  async initiateConsensus(proposal) {
    const roundId = `round_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

    this.votingRounds.set(roundId, {
      proposal,
      votes: new Map(),
      status: 'voting',
      startTime: Date.now(),
      timeout: 30000 // 30 seconds
    });

    // Broadcast proposal to all agents
    await this.broadcastProposal(roundId, proposal);

    // Collect votes
    const consensus = await this.collectVotes(roundId);

    return {
      roundId,
      consensus,
      achieved: consensus.support >= this.quorumThreshold,
      details: this.votingRounds.get(roundId)
    };
  }

  async broadcastProposal(roundId, proposal) {
    const messages = this.agents.map(agent => ({
      to: agent.id,
      type: 'consensus_proposal',
      roundId,
      proposal,
      quorum: this.quorumThreshold
    }));

    return Promise.all(messages.map(msg => this.sendMessage(msg)));
  }

  async collectVotes(roundId) {
    const round = this.votingRounds.get(roundId);
    const deadline = round.startTime + round.timeout;

    while (Date.now() < deadline) {
      if (round.votes.size >= this.agents.length) break;
      await this.delay(100); // Poll every 100ms
    }

    const votes = Array.from(round.votes.values());
    const support = votes.filter(v => v === 'approve').length;
    const reject = votes.filter(v => v === 'reject').length;
    const abstain = votes.filter(v => v === 'abstain').length;

    return { support, reject, abstain, total: votes.length };
  }

  async sendMessage(message) {
    // Implementation would interface with actual agent communication
    console.log(`Sending message to ${message.to}:`, message);
    return true;
  }

  async receiveVote(agentId, roundId, vote) {
    const round = this.votingRounds.get(roundId);
    if (round && round.status === 'voting') {
      round.votes.set(agentId, vote);
    }
  }

  delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}

module.exports = ConsensusProtocol;