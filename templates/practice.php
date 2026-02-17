<div class="practice-detail">
    <?php if(!empty($image)): ?>
        <img src="<?= htmlspecialchars($image) ?>" alt="<?= htmlspecialchars($title) ?>" style="max-width: 100%; margin-bottom: 2rem;">
    <?php endif; ?>

    <div class="practice-content" style="margin-bottom: 2rem;">
        <?= $content ?>
    </div>

    <p>
        <a href="<?= htmlspecialchars($launch_url) ?>" target="_blank" class="view-all">
            <?= $lang == 'en' ? 'Launch Practice' : 'Abrir Práctica' ?>
        </a>
    </p>
</div>
