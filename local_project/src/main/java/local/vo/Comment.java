package local.vo;

public class Comment extends CommentEdit {
	private int commentId; 		// 댓글ID
	private int boardId;		// 게시글ID
	private int createdBy;		// 등록한회원ID
	private String createdIp;	// 등록한사람IP
	private String createdAt;	// 등록일시
	private String content;		// 내용
	private String nicknm;		// 닉네임
	private char boardCode;
	
	
	
	
	public char getBoardCode() {
		return boardCode;
	}
	public void setBoardCode(char boardCode) {
		this.boardCode = boardCode;
	}
	
	public String getNicknm() {
		return nicknm;
	}
	public void setNicknm(String nicknm) {
		this.nicknm = nicknm;
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
	
	
	
	
	
}
