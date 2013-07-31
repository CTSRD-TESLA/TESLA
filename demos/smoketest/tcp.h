/*-
 * Copyright (c) 1982, 1986, 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	@(#)tcp.h	8.1 (Berkeley) 6/10/93
 * $FreeBSD$
 */

#include <sys/types.h>

#include "tcp_fsm.h"
#include "tesla-macros.h"

/*
 * Forward declarations of things that, in the kernel, would actually be
 * defined.
 */
struct inpcb;
struct tcp_timer;
struct toedev;

/*
 * Declarations that are a little bit more real.
 */
typedef	u_int32_t tcp_seq;

/*
 * Tcp control block, one per tcp; fields:
 * Organized for 16 byte cacheline efficiency.
 */
struct tcpcb {
#if REAL
	struct	tsegqe_head t_segq;	/* segment reassembly queue */
#endif
	void	*t_pspare[2];		/* new reassembly queue */
	int	t_segqlen;		/* segment reassembly queue length */
	int	t_dupacks;		/* consecutive dup acks recd */

	struct tcp_timer *t_timers;	/* All the TCP timers in one struct */

	struct	inpcb *t_inpcb;		/* back pointer to internet pcb */
	int	t_state;		/* state of this connection */
	u_int	t_flags;

	struct	vnet *t_vnet;		/* back pointer to parent vnet */

	tcp_seq	snd_una;		/* send unacknowledged */
	tcp_seq	snd_max;		/* highest sequence number sent;
					 * used to recognize retransmits
					 */
	tcp_seq	snd_nxt;		/* send next */
	tcp_seq	snd_up;			/* send urgent pointer */

	tcp_seq	snd_wl1;		/* window update seg seq number */
	tcp_seq	snd_wl2;		/* window update seg ack number */
	tcp_seq	iss;			/* initial send sequence number */
	tcp_seq	irs;			/* initial receive sequence number */

	tcp_seq	rcv_nxt;		/* receive next */
	tcp_seq	rcv_adv;		/* advertised window */
	u_long	rcv_wnd;		/* receive window */
	tcp_seq	rcv_up;			/* receive urgent pointer */

	u_long	snd_wnd;		/* send window */
	u_long	snd_cwnd;		/* congestion-controlled window */
	u_long	snd_spare1;		/* unused */
	u_long	snd_ssthresh;		/* snd_cwnd size threshold for
					 * for slow start exponential to
					 * linear switch
					 */
	u_long	snd_spare2;		/* unused */
	tcp_seq	snd_recover;		/* for use in NewReno Fast Recovery */

	u_int	t_maxopd;		/* mss plus options */

	u_int	t_rcvtime;		/* inactivity time */
	u_int	t_starttime;		/* time connection was established */
	u_int	t_rtttime;		/* RTT measurement start time */
	tcp_seq	t_rtseq;		/* sequence number being timed */

	u_int	t_bw_spare1;		/* unused */
	tcp_seq	t_bw_spare2;		/* unused */

	int	t_rxtcur;		/* current retransmit value (ticks) */
	u_int	t_maxseg;		/* maximum segment size */
	int	t_srtt;			/* smoothed round-trip time */
	int	t_rttvar;		/* variance in round-trip time */

	int	t_rxtshift;		/* log(2) of rexmt exp. backoff */
	u_int	t_rttmin;		/* minimum rtt allowed */
	u_int	t_rttbest;		/* best rtt we've seen */
	u_long	t_rttupdated;		/* number of times rtt sampled */
	u_long	max_sndwnd;		/* largest window peer has offered */

	int	t_softerror;		/* possible error not yet reported */
/* out-of-band data */
	char	t_oobflags;		/* have some */
	char	t_iobc;			/* input character */
/* RFC 1323 variables */
	u_char	snd_scale;		/* window scaling for send window */
	u_char	rcv_scale;		/* window scaling for recv window */
	u_char	request_r_scale;	/* pending window scaling */
	u_int32_t  ts_recent;		/* timestamp echo data */
	u_int	ts_recent_age;		/* when last updated */
	u_int32_t  ts_offset;		/* our timestamp offset */

	tcp_seq	last_ack_sent;
/* experimental */
	u_long	snd_cwnd_prev;		/* cwnd prior to retransmit */
	u_long	snd_ssthresh_prev;	/* ssthresh prior to retransmit */
	tcp_seq	snd_recover_prev;	/* snd_recover prior to retransmit */
	int	t_sndzerowin;		/* zero-window updates sent */
	u_int	t_badrxtwin;		/* window for retransmit recovery */
	u_char	snd_limited;		/* segments limited transmitted */
/* SACK related state */
#if REAL
	int	snd_numholes;		/* number of holes seen by sender */
	TAILQ_HEAD(sackhole_head, sackhole) snd_holes;
					/* SACK scoreboard (sorted) */
	tcp_seq	snd_fack;		/* last seq number(+1) sack'd by rcv'r*/
	int	rcv_numsacks;		/* # distinct sack blks present */
	struct sackblk sackblks[MAX_SACK_BLKS]; /* seq nos. of sack blocks */
	tcp_seq sack_newdata;		/* New data xmitted in this recovery
					   episode starts at this seq number */
	struct sackhint	sackhint;	/* SACK scoreboard hint */
#endif
	int	t_rttlow;		/* smallest observerved RTT */
	u_int32_t	rfbuf_ts;	/* recv buffer autoscaling timestamp */
	int	rfbuf_cnt;		/* recv buffer autoscaling byte count */
	struct toedev	*tod;		/* toedev handling this connection */
	int	t_sndrexmitpack;	/* retransmit packets sent */
	int	t_rcvoopack;		/* out-of-order packets received */
	void	*t_toe;			/* TOE pcb pointer */
	int	t_bytes_acked;		/* # bytes acked during current RTT */
	struct cc_algo	*cc_algo;	/* congestion control algorithm */
	struct cc_var	*ccv;		/* congestion control specific vars */
	struct osd	*osd;		/* storage for Khelp module data */

	u_int	t_keepinit;		/* time to establish connection */
	u_int	t_keepidle;		/* time before keepalive probes begin */
	u_int	t_keepintvl;		/* interval between keepalives */
	u_int	t_keepcnt;		/* number of keepalives before close */

	u_int32_t t_ispare[8];		/* 5 UTO, 3 TBD */
	void	*t_pspare2[4];		/* 4 TBD */
	u_int64_t _pad[6];		/* 6 TBD (1-2 CC/RTT?) */
};

#ifdef TESLA
#ifdef __TESLA_ANALYSER__
automaton(my_tcpcb_assertion, struct tcpcb *tp);
automaton(active_close, struct tcpcb*);
automaton(established, struct tcpcb*);

void	tcp_init(struct tcpcb*);
void	tcp_free(struct tcpcb*);

/*
 * Specify that the automaton 'my_tcpcb_assertion' describes the behaviour
 * of struct tcpcb.
 *
 * This is a global automaton: its state will be stored in a global store
 * and its events will trigger synchronisation.
 *
 * The automaton starts with the event 'call(tcp_init(tp))' and ends with
 * the event 'returnfrom(tcp_free(tp))'.
 */
TESLA_STRUCT_AUTOMATON(struct tcpcb *tp, my_tcpcb_assertion, __tesla_global,
                       call(tcp_init(tp)),
                       returnfrom(tcp_free(tp)));

automaton(my_tcpcb_assertion, struct tcpcb *tp)
{
	tp->t_state = TCPS_CLOSED;

	TSEQUENCE(
		tp->t_state = TCPS_LISTEN,
		optional(tp->t_state = TCPS_CLOSED),
		call(tcp_free(tp))
	)
	||
	TSEQUENCE(
		optional(tp->t_state = TCPS_SYN_SENT),
		TSEQUENCE(
			tp->t_state = TCPS_SYN_RECEIVED,
			established(tp) || active_close(tp)
		)
		||
		established(tp)
	)
	||
	call(tcp_free(tp));

	tesla_done;
}

automaton(active_close, struct tcpcb *tp)
{
	tp->t_state = TCPS_FIN_WAIT_1;

	TSEQUENCE(
		tp->t_state = TCPS_CLOSING,
		tp->t_state = TCPS_TIME_WAIT
	)
	||
	TSEQUENCE(
		tp->t_state = TCPS_FIN_WAIT_2,
		tp->t_state = TCPS_TIME_WAIT
	);

	tp->t_state = TCPS_CLOSED;
	call(tcp_free(tp));

	tesla_done;
}

automaton(established, struct tcpcb *tp)
{
	tp->t_state = TCPS_ESTABLISHED;

	active_close(tp)
	||
	TSEQUENCE(
		tp->t_state = TCPS_CLOSE_WAIT,
		tp->t_state = TCPS_LAST_ACK,
		optional(tp->t_state = TCPS_CLOSED)
	);

	call(tcp_free(tp));

	tesla_done;
}

#endif
#endif
