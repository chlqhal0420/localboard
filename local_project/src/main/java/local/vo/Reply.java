package local.vo;

public class Reply  {
	private int replyId;		// 답글 ID
	private int commentId;  	// 댓글 ID
	private int boardId;		// 게시글 ID
	private int createdBy;  	// 등록한 회원 ID
	private String createdIp;	// 등록한 사람 IP
	private String createdAt;	// 등록일시
	private String content;		// 내용
	private char delyn;			// 삭제여부
	private String nicknm;
	
	
	
	
	
	public String getNicknm() {
		return nicknm;
	}
	public void setNicknm(String nicknm) {
		this.nicknm = nicknm;
	}
	public int getReplyId() {
		return replyId;
	}
	public void setReplyId(int replyId) {
		this.replyId = replyId;
	}
	public int getCommentId() {
		return commentId;
	}
	public void setCommentId(int commentId) {
		this.commentId = commentId;
	}
	public int getBoardId() {
		return boardId;
	}
	public void setBoardId(int boardId) {
		this.boardId = boardId;
	}
	public int getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(int createdBy) {
		this.createdBy = createdBy;
	}
	public String getCreatedIp() {
		return createdIp;
	}
	public void setCreatedIp(String createdIp) {
		this.createdIp = createdIp;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public char getDelyn() {
		return delyn;
	}
	public void setDelyn(char delyn) {
		this.delyn = delyn;
	}
	
	
}
