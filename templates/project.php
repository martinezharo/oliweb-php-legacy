<div class="project-detail">
    <?php if(!empty($logo)): ?>
        <img src="<?= htmlspecialchars($logo) ?>" alt="<?= htmlspecialchars($title) ?>" style="max-width: 200px; margin-bottom: 2rem;">
    <?php endif; ?>
    
    <div class="project-content" style="margin-bottom: 2rem;">
        <?= $content ?>
    </div>

    <?php if(!empty($url)): ?>
        <p>
            <a href="<?= htmlspecialchars($url) ?>" target="_blank" class="view-all">
                <?= $lang == 'en' ? 'Visit Project' : 'Visitar Proyecto' ?>
            </a>
        </p>
    <?php endif; ?>
</div>
